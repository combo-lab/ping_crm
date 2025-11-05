defmodule PingCRM.Web.ProfileController do
  use PingCRM.Web, :controller

  alias PingCRM.Core.Accounts
  alias PingCRM.Web.UserJSON

  def edit(conn, _params) do
    current_user = conn.assigns.current_user

    inertia_render(conn, "Profile/Edit", %{
      user: serialize(current_user, {UserJSON, :edit})
    })
  end

  def update(conn, params) do
    current_user = conn.assigns.current_user

    case Accounts.update_user(current_user, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:success, "Profile updated.")
        |> redirect_back()

      {:error, changeset} ->
        conn
        |> inertia_put_errors(changeset)
        |> redirect_back()
    end
  end
end
