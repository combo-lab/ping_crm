defmodule PingCRM.Core.CRM.Contact do
  use PingCRM.Core.Schema

  alias PingCRM.Core.Accounts.Account
  alias PingCRM.Core.CRM.Org

  schema "contacts" do
    belongs_to :account, Account
    belongs_to :org, Org
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :address, :string
    field :city, :string
    field :region, :string
    field :country, :string
    field :postal_code, :string

    timestamps()
    field :deleted_at, :utc_datetime_usec
  end

  def full_name(%__MODULE__{} = contact) do
    "#{contact.first_name} #{contact.last_name}"
  end

  def changeset(contact, attrs) do
    contact
    |> Ecto.Changeset.cast(attrs, [
      :first_name,
      :last_name,
      :org_id,
      :email,
      :phone,
      :address,
      :city,
      :region,
      :country,
      :postal_code
    ])
    |> Ecto.Changeset.validate_required([:first_name, :last_name])
    |> Ecto.Changeset.validate_length(:first_name, max: 25)
    |> Ecto.Changeset.validate_length(:last_name, max: 25)
    |> Ecto.Changeset.foreign_key_constraint(:org_id)
    |> Ecto.Changeset.validate_length(:email, max: 50)
    |> Ecto.Changeset.validate_length(:phone, max: 50)
    |> Ecto.Changeset.validate_length(:address, max: 150)
    |> Ecto.Changeset.validate_length(:city, max: 50)
    |> Ecto.Changeset.validate_length(:region, max: 50)
    |> Ecto.Changeset.validate_length(:country, is: 2)
    |> Ecto.Changeset.validate_length(:postal_code, max: 25)
  end
end
