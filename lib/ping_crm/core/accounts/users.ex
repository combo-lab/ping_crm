defmodule PingCRM.Core.Accounts.Users do
  import Ecto.Query
  alias PingCRM.Core.Repo
  alias PingCRM.Core.SoftDeletion
  alias PingCRM.Core.Accounts.Account
  alias PingCRM.Core.Accounts.User

  def paginate_users(%Account{} = account, paginate_opts \\ [], filter_opts \\ []) do
    search = filter_opts[:search]
    role = filter_opts[:role]
    status = filter_opts[:status]

    User
    |> scope_by_account(account)
    |> filter_users_by_search(search)
    |> filter_users_by_role(role)
    |> filter_by_status(status)
    |> sort_users_by_role_and_name()
    |> Repo.paginate(paginate_opts)
  end

  def create_user(%Account{} = account, attrs) do
    %User{}
    |> User.changeset_create(attrs)
    |> Ecto.Changeset.put_assoc(:account, account)
    |> Repo.insert()
  end

  def get_user!(%Account{} = account, id) do
    User
    |> scope_by_account(account)
    |> Repo.get!(id)
  end

  def load_user_account!(%User{} = user) do
    Repo.preload(user, :account)
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset_update(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    user
    |> SoftDeletion.change_to_deleted()
    |> Repo.update()
  end

  def restore_user(%User{} = user) do
    user
    |> SoftDeletion.change_to_active()
    |> Repo.update()
  end

  def demo_user?(%User{} = user) do
    user.email == "johndoe@example.com"
  end

  defp scope_by_account(query, account) do
    where(query, [u], u.account_id == ^account.id)
  end

  defp filter_users_by_search(query, nil), do: query

  defp filter_users_by_search(query, search) do
    pattern = "%#{search}%"

    where(
      query,
      [u],
      ilike(u.first_name, ^pattern) or
        ilike(u.last_name, ^pattern) or
        ilike(u.email, ^pattern)
    )
  end

  defp filter_users_by_role(query, role) do
    case role do
      :owner -> where(query, [u], u.role == :owner)
      :user -> where(query, [u], u.role == :user)
      _ -> query
    end
  end

  defp filter_by_status(query, status) do
    case status do
      :all -> query
      :active -> SoftDeletion.filter_by_active(query)
      :deleted -> SoftDeletion.filter_by_deleted(query)
      _ -> SoftDeletion.filter_by_active(query)
    end
  end

  defp sort_users_by_role_and_name(query) do
    order_by(query, [u], [u.role, u.last_name, u.first_name])
  end
end
