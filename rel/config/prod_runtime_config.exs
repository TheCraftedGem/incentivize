use Mix.Config

port = String.to_integer(System.get_env("PORT"))

config :incentivize, Incentivize.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :incentivize, IncentivizeWeb.Endpoint,
  http: [port: port],
  url: [scheme: "https", host: System.get_env("APP_DOMAIN"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  server: true,
  root: "."

config :incentivize, :google_analytics_id, System.get_env("GOOGLE_ANALYTICS_ID")

config :rollbax,
  client_token: System.get_env("ROLLBAR_CLIENT_TOKEN"),
  access_token: System.get_env("ROLLBAR_SERVER_TOKEN"),
  environment: System.get_env("ROLLBAR_ENVIRONMENT"),
  enabled: true

config :incentivize, Incentivize.Github,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  app_id: System.get_env("GITHUB_APP_ID"),
  private_key: System.get_env("GITHUB_APP_PRIVATE_KEY"),
  app_slug: System.get_env("GITHUB_APP_SLUG")

config :incentivize, Incentivize.Stellar,
  # Defaults to test network
  network_url: System.get_env("STELLAR_NETWORK_URL"),
  public_key: System.get_env("STELLAR_PUBLIC_KEY"),
  secret: System.get_env("STELLAR_SECRET")

config :incentivize, :statix,
  prefix: "incentivize",
  host: System.get_env("DATADOG_HOST") || "localhost",
  port: String.to_integer(System.get_env("DATADOG_PORT") || "8125")

config :incentivize, :stellar_asset,
  code: System.get_env("STELLAR_ASSET_CODE") || "XLM",
  issuer: System.get_env("STELLAR_ASSET_ISSUER")

config :incentivize, :nodejs,
  timeout: String.to_integer(System.get_env("NODEJS_TIMEOUT") || "60000")
