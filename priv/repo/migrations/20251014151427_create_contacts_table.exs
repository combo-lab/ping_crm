defmodule PingCRM.Core.Repo.Migrations.CreateContactsTable do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :account_id, references(:accounts, on_delete: :delete_all), null: false
      add :org_id, references(:orgs, on_delete: :nilify_all)
      add :first_name, :varchar, null: false
      add :last_name, :varchar, null: false
      add :email, :varchar
      add :phone, :varchar
      add :address, :varchar
      add :city, :varchar
      add :region, :varchar
      add :country, :varchar
      add :postal_code, :varchar

      timestamps()
      add :deleted_at, :utc_datetime_usec
    end

    create index(:contacts, [:account_id])
    create index(:contacts, [:org_id])
  end
end
