use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :incentivize, IncentivizeWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

timeout = 60_000

# Configure your database
config :incentivize, Incentivize.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "incentivize_test",
  hostname: "localhost",
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_timeout: timeout,
  timeout: timeout,
  ownership_timeout: timeout

config :incentivize, :stellar_module, Incentivize.Stellar.Mock
config :incentivize, :github_repos_module, Incentivize.Github.API.Repos.Mock

if File.exists?(Path.join([__DIR__, "dev.secret.exs"])) do
  import_config "dev.secret.exs"
end
