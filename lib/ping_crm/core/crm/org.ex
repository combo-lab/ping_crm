defmodule PingCRM.Core.CRM.Org do
  use PingCRM.Core.Schema

  alias PingCRM.Core.Accounts.Account
  alias PingCRM.Core.CRM.Contact

  schema "orgs" do
    belongs_to :account, Account
    field :name, :string
    field :email, :string
    field :phone, :string
    field :address, :string
    field :city, :string
    field :region, :string
    field :country, :string
    field :postal_code, :string
    has_many :contacts, Contact

    timestamps()
    field :deleted_at, :utc_datetime_usec
  end

  def changeset(org, attrs) do
    org
    |> Ecto.Changeset.cast(attrs, [
      :name,
      :email,
      :phone,
      :address,
      :city,
      :region,
      :country,
      :postal_code
    ])
    |> Ecto.Changeset.validate_required([:name])
    |> Ecto.Changeset.validate_length(:name, max: 100)
    |> Ecto.Changeset.validate_length(:email, max: 50)
    |> Ecto.Changeset.validate_length(:phone, max: 50)
    |> Ecto.Changeset.validate_length(:address, max: 150)
    |> Ecto.Changeset.validate_length(:city, max: 50)
    |> Ecto.Changeset.validate_length(:region, max: 50)
    |> Ecto.Changeset.validate_length(:country, is: 2)
    |> Ecto.Changeset.validate_length(:postal_code, max: 25)
  end
end
