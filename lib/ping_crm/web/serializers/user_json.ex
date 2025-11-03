defmodule PingCRM.Web.UserJSON do
  use PingCRM.Web, :serializer

  alias PingCRM.Core.Accounts
  alias PingCRM.Core.Accounts.User
  alias PingCRM.Web.AccountJSON

  def serialize(%User{} = user, :auth) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      role: user.role,
      account: wrap_assoc(user.account, AccountJSON)
    }
  end

  def serialize(%User{} = user, :compact) do
    %{
      id: user.id,
      full_name: User.full_name(user),
      email: user.email,
      role: user.role,
      photo: Accounts.fetch_user_photo_url!(user.photo),
      deleted_at: user.deleted_at
    }
  end

  def serialize(%User{} = user, :edit) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      full_name: User.full_name(user),
      email: user.email,
      role: user.role,
      photo: Accounts.fetch_user_photo_url!(user.photo),
      deleted_at: user.deleted_at
    }
  end
end
