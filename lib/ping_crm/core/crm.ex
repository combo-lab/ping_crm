defmodule PingCRM.Core.CRM do
  import Ecto.Query
  alias PingCRM.Core.Repo
  alias PingCRM.Core.SoftDeletion
  alias PingCRM.Core.Accounts.Account
  alias PingCRM.Core.CRM.Org
  alias PingCRM.Core.CRM.Contact

  # Orgs

  def paginate_orgs(%Account{} = account, paginate_opts \\ [], filter_opts \\ []) do
    search = filter_opts[:search]
    status = filter_opts[:status]

    Org
    |> scope_by_account(account)
    |> filter_orgs_by_search(search)
    |> filter_by_status(status)
    |> sort_orgs_by_inserted_at()
    |> Repo.paginate(paginate_opts)
  end

  def list_orgs(%Account{} = account) do
    Org
    |> scope_by_account(account)
    |> sort_orgs_by_name()
    |> Repo.all()
  end

  def get_org!(%Account{} = account, id) do
    Org
    |> scope_by_account(account)
    |> Repo.get!(id)
  end

  def create_org(%Account{} = account, attrs) do
    %Org{}
    |> Org.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:account, account)
    |> Repo.insert()
  end

  def update_org(%Org{} = org, attrs) do
    org
    |> Org.changeset(attrs)
    |> Repo.update()
  end

  def delete_org(%Org{} = org) do
    org
    |> SoftDeletion.change_to_deleted()
    |> Repo.update()
  end

  def restore_org(%Org{} = org) do
    org
    |> SoftDeletion.change_to_active()
    |> Repo.update()
  end

  def load_org_contacts!(org_or_orgs) do
    Repo.preload(org_or_orgs, :contacts)
  end

  defp filter_orgs_by_search(query, nil), do: query

  defp filter_orgs_by_search(query, search) do
    pattern = "%#{search}%"
    where(query, [o], ilike(o.name, ^pattern))
  end

  defp sort_orgs_by_inserted_at(query) do
    order_by(query, [_o], desc: :inserted_at)
  end

  defp sort_orgs_by_name(query) do
    order_by(query, [_o], asc: :name)
  end

  # Contacts

  def paginate_contacts(%Account{} = account, paginate_opts \\ [], filter_opts \\ []) do
    search = filter_opts[:search]
    status = filter_opts[:status]

    Contact
    |> scope_by_account(account)
    |> filter_contacts_by_search(search)
    |> filter_by_status(status)
    |> sort_contacts_by_name()
    |> Repo.paginate(paginate_opts)
  end

  def get_contact!(%Account{} = account, id) do
    Contact
    |> scope_by_account(account)
    |> Repo.get!(id)
  end

  def create_contact(%Account{} = account, attrs) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:account, account)
    |> Repo.insert()
  end

  def create_contact(%Account{} = account, %Org{} = org, attrs) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:account, account)
    |> Ecto.Changeset.put_assoc(:org, org)
    |> Repo.insert()
  end

  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  def delete_contact(%Contact{} = contact) do
    contact
    |> SoftDeletion.change_to_deleted()
    |> Repo.update()
  end

  def restore_contact(%Contact{} = contact) do
    contact
    |> SoftDeletion.change_to_active()
    |> Repo.update()
  end

  def load_contact_org!(contact_or_contacts) do
    Repo.preload(contact_or_contacts, :org)
  end

  defp filter_contacts_by_search(query, nil), do: query

  defp filter_contacts_by_search(query, search) do
    pattern = "%#{search}%"

    query
    |> join(:left, [c], o in assoc(c, :org))
    |> where(
      [c, o],
      ilike(c.first_name, ^pattern) or
        ilike(c.last_name, ^pattern) or
        ilike(c.email, ^pattern) or
        ilike(o.name, ^pattern)
    )
  end

  defp sort_contacts_by_name(query) do
    order_by(query, [c], [c.last_name, c.first_name])
  end

  # Shared

  defp scope_by_account(query, account) do
    where(query, [o], o.account_id == ^account.id)
  end

  defp filter_by_status(query, status) do
    case status do
      :all -> query
      :active -> SoftDeletion.filter_by_active(query)
      :deleted -> SoftDeletion.filter_by_deleted(query)
      _ -> SoftDeletion.filter_by_active(query)
    end
  end
end
