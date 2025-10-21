defmodule PingCRM.Core.Repo.Migrations.CreateUserSessionTokensTable do
  use Ecto.Migration

  def change do
    create table(:user_session_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token_hash, :binary, null: false
      add :meta, :map, null: false, default: %{}

      timestamps(updated_at: false)
    end

    create index(:user_session_tokens, [:user_id])
    create unique_index(:user_session_tokens, [:token_hash])
  end
end
