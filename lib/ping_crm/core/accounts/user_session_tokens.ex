defmodule PingCRM.Core.Accounts.UserSessionTokens do
  import Ecto.Query
  import PingCRM.Core.EasyFlow
  alias PingCRM.Core.EasyToken
  alias PingCRM.Core.Repo
  alias PingCRM.Core.Accounts.User
  alias PingCRM.Core.Accounts.UserSessionToken

  @token_format {:binary, size: 32}

  @type meta :: map()
  @type token :: String.t()

  @spec create_user_session_token!(User.t(), meta()) :: token()
  def create_user_session_token!(user, meta \\ %{}) do
    {token, token_hash} = EasyToken.generate(@token_format)

    # Do not use upsert here. Otherwise, a token conflict could allow one user
    # to access another user's resources.
    # If a conflict does occur, then let it crash.
    Repo.insert!(%UserSessionToken{
      user_id: user.id,
      token_hash: token_hash,
      meta: meta
    })

    token
  end

  @spec fetch_user_session_token(token()) :: {:ok, UserSessionToken.t()} | :error
  def fetch_user_session_token(token) do
    with {:ok, token_hash} <- EasyToken.hash(@token_format, token),
         user_session_token = Repo.one(query_valid_user_session_tokens(token_hash: token_hash)),
         :ok <- if_else(user_session_token),
         do: {:ok, user_session_token},
         else: (_ -> :error)
  end

  @spec fetch_user_by_user_session_token(UserSessionToken.t()) :: {:ok, User.t()} | :error
  def fetch_user_by_user_session_token(user_session_token) do
    user =
      user_session_token
      |> Ecto.assoc(:user)
      |> Repo.one()

    if user, do: {:ok, user}, else: :error
  end

  @spec delete_user_session_token(token()) :: :ok
  def delete_user_session_token(token) do
    with {:ok, token_hash} <- EasyToken.hash(@token_format, token) do
      Repo.delete_all(query_valid_user_session_tokens(token_hash: token_hash))
    end

    :ok
  end

  @spec cleanup_user_session_tokens() :: :ok
  def cleanup_user_session_tokens do
    Repo.delete_all(query_invalid_user_session_tokens())
    :ok
  end

  defp query_valid_user_session_tokens, do: where(UserSessionToken, ^filter_unexpired())

  defp query_valid_user_session_tokens(criteria) do
    filter =
      Enum.map(criteria, fn
        {:user, user} -> {:user_id, user.id}
        {field, value} -> {field, value}
      end)

    where(query_valid_user_session_tokens(), ^filter)
  end

  defp query_invalid_user_session_tokens, do: where(UserSessionToken, ^filter_expired())

  defp filter_unexpired do
    dynamic(
      [user_session_token],
      user_session_token.inserted_at >= ago(^UserSessionToken.ttl_in_minutes(), "minute")
    )
  end

  defp filter_expired do
    dynamic(not (^filter_unexpired()))
  end
end
