defmodule PingCRM.Core.Accounts.UserSessionToken do
  use PingCRM.Core.Schema
  alias PingCRM.Core.Accounts.User

  schema "user_session_tokens" do
    belongs_to :user, User
    field :token_hash, :binary
    field :meta, :map

    timestamps(updated_at: false)
  end

  # Since expired session token requires user to log in again, in order to
  # minimize the impact on users' continuous usage experience as much as
  # possible, it's important to set the ttl long enough. Default to
  # `30 * 24 * 60`, which means 30 days.
  @ttl_in_minutes 30 * 24 * 60

  @spec ttl_in_minutes() :: pos_integer()
  def ttl_in_minutes, do: @ttl_in_minutes

  @spec ttl_in_seconds() :: pos_integer()
  def ttl_in_seconds, do: @ttl_in_minutes * 60
end
