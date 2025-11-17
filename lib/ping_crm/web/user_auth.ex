defmodule PingCRM.Web.UserAuth do
  import Plug.Conn
  import Combo.Conn
  alias PingCRM.Core.Accounts
  alias PingCRM.Web.Router.Helpers, as: Routes

  # The rotation of user session tokens.
  #
  # When a request is made with a user session token older than this value, then
  # a new session token will be created.
  # To disable the rotation of user session tokens completely, set a value greater
  # than `Accounts.UserSessionToken.ttl_in_minutes()`.
  @user_session_token_rotation_interval_in_minutes Accounts.user_session_token_ttl_in_minutes()
                                                   |> Kernel./(2)
                                                   |> ceil()

  @doc """
  Logs the user in.

  Redirects to the session's `:user_return_to` path or falls back to the
  `signed_in_path/1`.
  """
  def log_in_user(conn, user) do
    redirect_to = get_user_return_to(conn) || signed_in_path(conn)

    conn
    |> create_user_session(user)
    |> redirect(to: redirect_to)
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See private function `renew_user_session`.
  """
  def log_out_user(conn) do
    conn
    |> delete_user_session()
    |> redirect(to: Routes.user_session_path(conn, :show))
  end

  @doc """
  The plug for getting the current user.

  It will rotate the session token if it is older than the configured age.
  """
  def fetch_current_user(conn, _opts) do
    with {:ok, token} <- fetch_user_session_token(conn),
         {:ok, user_session_token} <- Accounts.fetch_user_session_token(token),
         {:ok, user} <- Accounts.fetch_user_by_user_session_token(user_session_token),
         user <- Accounts.load_user_account!(user) do
      conn
      |> assign(:current_user, user)
      |> assign(:current_account, user.account)
      |> maybe_rotate_user_session(user, user_session_token.inserted_at)
    else
      :error -> assign(conn, :current_user, nil)
    end
  end

  @doc """
  The plug for routes that require the user to be authenticated.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_put_user_return_to()
      |> redirect(to: Routes.user_session_path(conn, :show))
      |> halt()
    end
  end

  @doc """
  The plug for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns.current_user do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  defp create_user_session(conn, user) do
    token = Accounts.create_user_session_token!(user)

    conn
    |> renew_user_session()
    |> put_user_session_token(token)
  end

  defp rotate_user_session(conn, user) do
    token = Accounts.create_user_session_token!(user)

    conn
    # When rotating session, the user is already logged in, do not operate on
    # session data except token, to prevent CSRF errors or losing session data.
    |> put_user_session_token(token)
  end

  defp delete_user_session(conn) do
    case fetch_user_session_token(conn) do
      {:ok, token} -> Accounts.delete_user_session_token(token)
      _ -> :ignore
    end

    conn
    |> renew_user_session()
  end

  defp maybe_rotate_user_session(conn, user, token_inserted_at) do
    token_age = DateTime.diff(DateTime.utc_now(:second), token_inserted_at, :minute)

    if token_age >= @user_session_token_rotation_interval_in_minutes,
      do: rotate_user_session(conn, user),
      else: conn
  end

  # Renews the session and erases the whole session to avoid fixation attacks.
  #
  # If there is any data in the session you may want to preserve after log in/
  # log out, you must explicitly fetch the session data before clearing and
  # then immediately set it after clearing, for example:
  #
  #     defp renew_user_session(conn) do
  #       delete_csrf_token()
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_user_session(conn) do
    delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp put_user_session_token(conn, token), do: put_session(conn, :user_token, token)

  defp fetch_user_session_token(conn) do
    if token = get_session(conn, :user_token), do: {:ok, token}, else: :error
  end

  defp maybe_put_user_return_to(conn) do
    case conn do
      %{method: "GET"} -> put_user_return_to(conn, current_path(conn))
      _ -> conn
    end
  end

  defp put_user_return_to(conn, path), do: put_session(conn, :user_return_to, path)
  defp get_user_return_to(conn), do: get_session(conn, :user_return_to)

  defp signed_in_path(conn), do: Routes.dashboard_path(conn, :show)
end
