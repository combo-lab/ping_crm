defmodule PingCRM.Web.OrgJSON do
  use PingCRM.Web, :serializer

  alias PingCRM.Core.CRM.Org
  alias PingCRM.Web.ContactJSON

  @impl true
  def serialize(%Org{} = org, :compact) do
    %{
      id: org.id,
      name: org.name,
      phone: org.phone,
      city: org.city,
      deleted_at: org.deleted_at
    }
  end

  @impl true
  def serialize(%Org{} = org, :edit) do
    %{
      id: org.id,
      name: org.name,
      email: org.email,
      phone: org.phone,
      address: org.address,
      city: org.city,
      region: org.region,
      country: org.country,
      postal_code: org.postal_code,
      deleted_at: org.deleted_at,
      contacts: wrap_assoc(org.contacts, {ContactJSON, :assoc})
    }
  end

  @impl true
  def serialize(%Org{} = org, :assoc) do
    %{
      id: org.id,
      name: org.name
    }
  end

  @impl true
  def serialize(%Org{} = org, :name) do
    %{
      id: org.id,
      name: org.name
    }
  end
end
