import Config

# Do not include metadata nor timestamps in development logs.
config :logger, :default_formatter, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation.
config :combo, :plug_init_mode, :runtime

# Include CEEx debug annotations as HTML comments in rendered markup.
# Changing it requires `mix clean` and a full recompile.
config :combo, :template, ceex_debug_annotations: true

# Set a higher stacktrace during development.
# Avoid configuring it in production as building large stacktraces may be expensive.
config :ping_crm, :stacktrace_depth, 20

config :ping_crm, PingCRM.Core.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ping_crm_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :ping_crm, PingCRM.Web.Endpoint,
  live_reloader: [
    patterns: [
      ~r"lib/ping_crm/web/router\.ex",
      ~r"lib/ping_crm/web/(controllers|layouts|components)/.*\.(ex|ceex)$"
    ]
  ],
  code_reloader: true,
  debug_errors: true,
  watchers: [
    pnpm: ["run", "dev", cd: Path.expand("../assets", __DIR__)]
  ],
  check_origin: false,
  secret_key_base: "RGtRvZO0P376QDG1kvb6twwVQM+wXDM8Ze+J9ctrZAyNLNZKFx7Z0hg4vi4lQlr1p"
