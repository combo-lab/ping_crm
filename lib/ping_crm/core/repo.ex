defmodule PingCRM.Core.Repo do
  use Ecto.Repo,
    otp_app: :ping_crm,
    adapter: Ecto.Adapters.Postgres
end
