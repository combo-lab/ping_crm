defmodule PingCRM.Web.UserController do
  use PingCRM.Web, :controller

  alias PingCRM.Core.Accounts
  alias PingCRM.Web.UserJSON

  def index(conn, params) do
    page = if page = Map.get(params, "page"), do: String.to_integer(page)
    paginate_opts = [page: page]

    search = Map.get(params, "search")
    role = if role = Map.get(params, "role"), do: String.to_existing_atom(role)
    status = if status = Map.get(params, "status"), do: String.to_existing_atom(status)
    filter_opts = [search: search, role: role, status: status]

    current_account = conn.assigns.current_account

    {users, pagination_meta} =
      Accounts.paginate_users(current_account, paginate_opts, filter_opts)

    inertia_render(conn, "User/Index", %{
      filters: Map.take(params, ["search", "role", "status"]),
      users: serialize(users, {UserJSON, :compact}),
      pagination_meta: pagination_meta
    })
  end

  def new(conn, _params) do
    inertia_render(conn, "User/New")
  end

  def create(conn, params) do
    current_account = conn.assigns.current_account
    {photo, params} = Map.pop(params, "photo")

    case Accounts.create_user(current_account, params) do
      {:ok, user} ->
        if photo do
          {:ok, _} =
            Accounts.update_user(user, %{
              "photo" => Accounts.store_user_photo!(user, photo)
            })
        end

        conn
        |> put_flash(:success, "User created.")
        |> redirect(to: ~p"/users")

      {:error, changeset} ->
        conn
        |> inertia_put_errors(changeset)
        |> redirect_back()
    end
  end

  def edit(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    user = Accounts.get_user!(current_account, id)

    inertia_render(conn, "User/Edit", %{
      user: serialize(user, {UserJSON, :edit})
    })
  end

  def update(conn, %{"id" => id} = params) do
    current_account = conn.assigns.current_account
    user = Accounts.get_user!(current_account, id)
    {photo, params} = Map.pop(params, "photo")

    case Accounts.update_user(user, params) do
      {:ok, user} ->
        if photo do
          {:ok, _} =
            Accounts.update_user(user, %{
              "photo" => Accounts.store_user_photo!(user, photo)
            })
        end

        conn
        |> put_flash(:success, "User updated.")
        |> redirect_back()

      {:error, changeset} ->
        conn
        |> inertia_put_errors(changeset)
        |> redirect_back()
    end
  end

  def delete(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    user = Accounts.get_user!(current_account, id)

    case Accounts.delete_user(user) do
      {:ok, _user} ->
        conn
        |> put_flash(:success, "User deleted.")
        |> redirect_back()

      {:error, _} ->
        conn
        |> put_flash(:success, "Failed to delete user.")
        |> redirect_back()
    end
  end

  def restore(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    user = Accounts.get_user!(current_account, id)

    case Accounts.restore_user(user) do
      {:ok, _user} ->
        conn
        |> put_flash(:success, "User restored.")
        |> redirect_back()

      {:error, _} ->
        conn
        |> put_flash(:success, "Failed to restore user.")
        |> redirect_back()
    end
  end
end
