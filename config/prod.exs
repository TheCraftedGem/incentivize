use Mix.Config

config :incentivize, IncentivizeWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: System.get_env("APP_DOMAIN"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: true,
  root: ".",
  version: Application.spec(:incentivize, :vsn)

config :incentivize, Incentivize.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true,
  loggers: [{Ecto.LogEntry, :log, []}, {Incentivize.Metrics, :record_ecto_metric, []}]

# Do not print debug messages in production
config :logger, level: :info

config :rollbax, enable_crash_reports: true
