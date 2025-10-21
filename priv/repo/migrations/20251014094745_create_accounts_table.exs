defmodule PingCRM.Core.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :varchar, null: false
      timestamps()
    end
  end
end
