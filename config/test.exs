import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :synai_pro, SynaiPro.Repo,
  username: "postgres",
  password: "postgres",
  database: "synai_pro_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :synai_pro, SynaiProWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "cPNzM6yNbuYM9FcYYtqL/PPFpiGQD5Tdxe4pRe8KYGFJ8gwI3Zgl6VL80H6pFeOp",
  server: true

# In test we don't send emails.
config :synai_pro, SynaiPro.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :email_checker, validations: [EmailChecker.Check.Format]
config :synai_pro, :env, :test

# Wallaby related settings:
config :wallaby, otp_app: :synai_pro, screenshot_on_failure: true, js_logger: nil
config :synai_pro, :sandbox, Ecto.Adapters.SQL.Sandbox

# Oban - Disable plugins, enqueueing scheduled jobs and job dispatching altogether when testing
config :synai_pro, Oban, testing: :inline
