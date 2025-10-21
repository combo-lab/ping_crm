defmodule PingCRM.Web.ContactJSON do
  use PingCRM.Web, :serializer

  alias PingCRM.Core.CRM.Contact
  alias PingCRM.Web.OrgJSON

  @impl true
  def serialize(%Contact{} = contact, :compact) do
    %{
      id: contact.id,
      full_name: Contact.full_name(contact),
      phone: contact.phone,
      city: contact.city,
      deleted_at: contact.deleted_at,
      org: wrap_assoc(contact.org, {OrgJSON, :assoc})
    }
  end

  @impl true
  def serialize(%Contact{} = contact, :edit) do
    %{
      id: contact.id,
      first_name: contact.first_name,
      last_name: contact.last_name,
      full_name: Contact.full_name(contact),
      email: contact.email,
      phone: contact.phone,
      address: contact.address,
      city: contact.city,
      region: contact.region,
      country: contact.country,
      postal_code: contact.postal_code,
      deleted_at: contact.deleted_at,
      org_id: contact.org_id
    }
  end

  @impl true
  def serialize(%Contact{} = contact, :assoc) do
    %{
      id: contact.id,
      full_name: Contact.full_name(contact),
      phone: contact.phone,
      city: contact.city
    }
  end
end
