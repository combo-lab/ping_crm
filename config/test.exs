import Config

# Print only warnings and errors during test.
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation.
config :combo, :plug_init_mode, :runtime

# Configure the database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ping_crm, PingCRM.Core.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ping_crm_test#{System.get_env("PING_CRM_MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# Configure the endpoint
#
# Don't run a server during test. If one is required, enable the :server
# option below.
config :ping_crm, PingCRM.Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4101],
  secret_key_base: "HT7/0T8G3+vYjaeuygCQh7uNyFcvL6XMooFiyW2oudRIsE3CarvW/GuvEGFywcHqU",
  server: false
