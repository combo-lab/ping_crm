defmodule PingCRM.Core.Repo.Migrations.CreateOrgsTable do
  use Ecto.Migration

  def change do
    create table(:orgs) do
      add :account_id, references(:accounts, on_delete: :delete_all), null: false
      add :name, :varchar, null: false
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

    create index(:orgs, [:account_id])
  end
end
