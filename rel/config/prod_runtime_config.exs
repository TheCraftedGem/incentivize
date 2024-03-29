use Mix.Config

port = String.to_integer(System.get_env("PORT"))

config :incentivize, Incentivize.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :incentivize, IncentivizeWeb.Endpoint,
  http: [port: port, compress: true],
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

config :incentivize, Incentivize.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :incentivize, Incentivize.Github.App,
  app_id: System.get_env("GITHUB_APP_ID"),
  private_key: System.get_env("GITHUB_APP_PRIVATE_KEY"),
  app_slug: System.get_env("GITHUB_APP_SLUG"),
  webhook_secret: System.get_env("GITHUB_APP_WEBHOOK_SECRET")

config :incentivize, Incentivize.Stellar,
  # Defaults to test network
  network_url: System.get_env("STELLAR_NETWORK_URL"),
  public_key: System.get_env("STELLAR_PUBLIC_KEY"),
  secret: System.get_env("STELLAR_SECRET")

config :stellar, network: System.get_env("STELLAR_NETWORK_URL")

config :incentivize, :statix,
  prefix: "incentivize",
  host: System.get_env("DATADOG_HOST") || "localhost",
  port: String.to_integer(System.get_env("DATADOG_PORT") || "8125")

config :incentivize, :stellar_asset,
  code: System.get_env("STELLAR_ASSET_CODE") || "XLM",
  issuer: System.get_env("STELLAR_ASSET_ISSUER")

config :incentivize, :nodejs,
  timeout: String.to_integer(System.get_env("NODEJS_TIMEOUT") || "60000")

config :incentivize,
       :cache_ttl,
       String.to_integer(System.get_env("CACHE_TTL") || "3600000")

config :incentivize, Incentivize.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")

config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), :instance_role]

config :incentivize, :s3_bucket, System.get_env("AWS_S3_BUCKET")

enable_pricing? = String.to_existing_atom(System.get_env("ENABLE_PRICING") || "false")

config :incentivize, :flags, pricing: enable_pricing?
