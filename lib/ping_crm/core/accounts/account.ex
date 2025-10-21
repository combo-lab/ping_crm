defmodule PingCRM.Core.Accounts.Account do
  use PingCRM.Core.Schema
  alias PingCRM.Core.Accounts.User
  alias PingCRM.Core.CRM.Org
  alias PingCRM.Core.CRM.Contact

  schema "accounts" do
    field :name, :string
    has_many :users, User
    has_many :orgs, Org
    has_many :contacts, Contact

    timestamps()
  end

  def changeset(account, attrs) do
    account
    |> Ecto.Changeset.cast(attrs, [:name])
    |> Ecto.Changeset.validate_required([:name])
    |> Ecto.Changeset.validate_length(:name, max: 50)
  end
end
