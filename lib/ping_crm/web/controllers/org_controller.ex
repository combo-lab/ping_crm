defmodule PingCRM.Web.OrgController do
  use PingCRM.Web, :controller

  alias PingCRM.Core.CRM
  alias PingCRM.Web.OrgJSON

  def index(conn, params) do
    page = if page = Map.get(params, "page"), do: String.to_integer(page)
    paginate_opts = [page: page]

    search = Map.get(params, "search")
    status = if status = Map.get(params, "status"), do: String.to_existing_atom(status)
    filter_opts = [search: search, status: status]

    current_account = conn.assigns.current_account
    {orgs, pagination_meta} = CRM.paginate_orgs(current_account, paginate_opts, filter_opts)

    inertia_render(conn, "Org/Index", %{
      filters: Map.take(params, ["search", "status"]),
      orgs: serialize(orgs, {OrgJSON, :compact}),
      pagination_meta: pagination_meta
    })
  end

  def new(conn, _params) do
    inertia_render(conn, "Org/New")
  end

  def create(conn, params) do
    current_account = conn.assigns.current_account

    case CRM.create_org(current_account, params) do
      {:ok, _org} ->
        conn
        |> put_flash(:success, "Organization created.")
        |> redirect(to: ~p"/orgs")

      {:error, changeset} ->
        conn
        |> inertia_put_errors(changeset)
        |> redirect(to: ~p"/orgs/new")
    end
  end

  def edit(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    org = current_account |> CRM.get_org!(id) |> CRM.load_org_contacts!()

    inertia_render(conn, "Org/Edit", %{
      org: serialize(org, {OrgJSON, :edit})
    })
  end

  def update(conn, %{"id" => id} = params) do
    current_account = conn.assigns.current_account
    org = CRM.get_org!(current_account, id)

    case CRM.update_org(org, params) do
      {:ok, _org} ->
        conn
        |> put_flash(:success, "Organization updated.")
        |> redirect(to: ~p"/orgs/#{org}/edit")

      {:error, changeset} ->
        conn
        |> inertia_put_errors(changeset)
        |> redirect(to: ~p"/orgs/#{org}/edit")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    org = CRM.get_org!(current_account, id)

    case CRM.delete_org(org) do
      {:ok, org} ->
        conn
        |> put_flash(:success, "Organization deleted.")
        |> redirect(to: ~p"/orgs/#{org}/edit")

      {:error, _} ->
        conn
        |> put_flash(:success, "Failed to delete organization.")
        |> redirect(to: ~p"/orgs/#{org}/edit")
    end
  end

  def restore(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    org = CRM.get_org!(current_account, id)

    case CRM.restore_org(org) do
      {:ok, org} ->
        conn
        |> put_flash(:success, "Organization restored.")
        |> redirect(to: ~p"/orgs/#{org}/edit")

      {:error, _} ->
        conn
        |> put_flash(:success, "Failed to restore organization.")
        |> redirect(to: ~p"/orgs/#{org}/edit")
    end
  end
end
