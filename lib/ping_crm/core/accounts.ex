defmodule PingCRM.Core.Accounts do
  alias PingCRM.Core.Repo
  alias PingCRM.Core.Accounts.Account
  alias PingCRM.Core.Accounts.UserAuth
  alias PingCRM.Core.Accounts.Users
  alias PingCRM.Core.Accounts.UserPhotos
  alias PingCRM.Core.Accounts.UserSessionTokens
  alias PingCRM.Core.Accounts.UserSessionToken

  def get_account(id) do
    Repo.get(Account, id)
  end

  def create_account(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  defdelegate get_user_by_email_and_password(email, password), to: UserAuth

  defdelegate paginate_users(account, paginate_opts, filter_opts), to: Users
  defdelegate create_user(account, attrs), to: Users
  defdelegate get_user!(account, id), to: Users
  defdelegate load_user_account!(user), to: Users
  defdelegate update_user(user, attrs), to: Users
  defdelegate delete_user(user), to: Users
  defdelegate restore_user(user), to: Users
  defdelegate demo_user?(user), to: Users

  defdelegate store_user_photo!(user, plug_upload), to: UserPhotos, as: :store!
  defdelegate fetch_user_photo_url!(photo), to: UserPhotos, as: :fetch_url!

  def user_session_token_ttl_in_minutes, do: UserSessionToken.ttl_in_minutes()
  def user_session_token_ttl_in_seconds, do: UserSessionToken.ttl_in_seconds()
  defdelegate create_user_session_token!(user, meta \\ %{}), to: UserSessionTokens
  defdelegate fetch_user_session_token(token), to: UserSessionTokens
  defdelegate fetch_user_by_user_session_token(user_session_token), to: UserSessionTokens
  defdelegate delete_user_session_token(token), to: UserSessionTokens
end
