defmodule PingCRM.Web.ContactController do
  use PingCRM.Web, :controller

  alias PingCRM.Core.CRM
  alias PingCRM.Web.OrgJSON
  alias PingCRM.Web.ContactJSON

  def index(conn, params) do
    page = if page = Map.get(params, "page"), do: String.to_integer(page)
    paginate_opts = [page: page]

    search = Map.get(params, "search")
    status = if status = Map.get(params, "status"), do: String.to_existing_atom(status)
    filter_opts = [search: search, status: status]

    current_account = conn.assigns.current_account

    {contacts, pagination_meta} =
      CRM.paginate_contacts(current_account, paginate_opts, filter_opts)

    contacts = CRM.load_contact_org!(contacts)

    inertia_render(conn, "Contact/Index", %{
      filters: Map.take(params, ["search", "status"]),
      contacts: serialize(contacts, {ContactJSON, :compact}),
      pagination_meta: pagination_meta
    })
  end

  def new(conn, _params) do
    current_account = conn.assigns.current_account
    orgs = CRM.list_orgs(current_account)

    inertia_render(conn, "Contact/New", %{
      org_names: serialize(orgs, {OrgJSON, :name})
    })
  end

  def create(conn, params) do
    current_account = conn.assigns.current_account

    case CRM.create_contact(current_account, params) do
      {:ok, _contact} ->
        conn
        |> put_flash(:success, "Contact created.")
        |> redirect(to: ~p"/contacts")

      {:error, changeset} ->
        conn
        |> inertia_put_errors(changeset)
        |> redirect_back()
    end
  end

  def edit(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    contact = CRM.get_contact!(current_account, id)
    orgs = CRM.list_orgs(current_account)

    inertia_render(conn, "Contact/Edit", %{
      contact: serialize(contact, {ContactJSON, :edit}),
      org_names: serialize(orgs, {OrgJSON, :name})
    })
  end

  def update(conn, %{"id" => id} = params) do
    current_account = conn.assigns.current_account
    contact = CRM.get_contact!(current_account, id)

    case CRM.update_contact(contact, params) do
      {:ok, _contact} ->
        conn
        |> put_flash(:success, "Contact updated.")
        |> redirect_back()

      {:error, changeset} ->
        conn
        |> inertia_put_errors(changeset)
        |> redirect_back()
    end
  end

  def delete(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    contact = CRM.get_contact!(current_account, id)

    case CRM.delete_contact(contact) do
      {:ok, _contact} ->
        conn
        |> put_flash(:success, "Contact deleted.")
        |> redirect_back()

      {:error, _} ->
        conn
        |> put_flash(:success, "Failed to delete contact.")
        |> redirect_back()
    end
  end

  def restore(conn, %{"id" => id}) do
    current_account = conn.assigns.current_account
    contact = CRM.get_contact!(current_account, id)

    case CRM.restore_contact(contact) do
      {:ok, _contact} ->
        conn
        |> put_flash(:success, "Contact restored.")
        |> redirect_back()

      {:error, _} ->
        conn
        |> put_flash(:success, "Failed to restore contact.")
        |> redirect_back()
    end
  end
end
