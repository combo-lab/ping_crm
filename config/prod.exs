import Config

# Do not print debug messages.
config :logger, level: :info

config :ping_crm, PingCRM.Web.Endpoint,
  inertia: [
    ssr: true
  ]
