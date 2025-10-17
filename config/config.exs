import Config

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ping_crm, ecto_repos: [PingCRM.Core.Repo]

config :ping_crm, PingCRM.Core.Repo,
  priv: "priv/repo",
  migration_primary_key: [name: :id, type: :binary_id],
  migration_timestamps: [type: :utc_datetime_usec]

config :ping_crm, PingCRM.Web.Endpoint,
  render_errors: [
    layout: [html: false, json: false],
    formats: [html: PingCRM.Web.ErrorHTML, json: PingCRM.Web.ErrorJSON]
  ],
  pubsub_server: PingCRM.PubSub

# Import environment specific config
#
# This must remain at the bottom of this file so it overrides the config
# defined above.
import_config "#{config_env()}.exs"
