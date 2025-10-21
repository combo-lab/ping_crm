defmodule PingCRM.Core.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :account_id, references(:accounts, on_delete: :delete_all), null: false
      add :first_name, :varchar, null: false
      add :last_name, :varchar, null: false
      add :email, :varchar, null: false
      add :password_hash, :binary, null: false
      add :role, :varchar, null: false
      add :photo, :varchar

      timestamps()
      add :deleted_at, :utc_datetime_usec
    end

    create index(:users, [:account_id])
    create unique_index(:users, [:email])
  end
end
