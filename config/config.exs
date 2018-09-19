# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :incentivize,
  ecto_repos: [Incentivize.Repo]

# Configures the endpoint
config :incentivize, IncentivizeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2ICx98yJO4b08TwDLYwn4iFDWkxDwOqzCR6wyk0O1giiPBr3MvI9ySwg6o7dKeeu",
  render_errors: [view: IncentivizeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Incentivize.PubSub, adapter: Phoenix.PubSub.PG2],
  instrumenters: [IncentivizeWeb.Instrumenter]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :incentivize, Incentivize.Github,
  client_id: nil,
  client_secret: nil,
  app_id: nil,
  private_key: nil,
  public_url: nil

config :incentivize, Incentivize.Stellar,
  # Defaults to test network
  network_url: "https://horizon-testnet.stellar.org",
  public_key: nil,
  secret: nil

config :rollbax,
  enabled: false,
  environment: "dev"

config :incentivize, :statix,
  prefix: "incentivize",
  host: "localhost",
  port: 8125

config(
  :vmstats,
  sink: Incentivize.Metrics,
  base_key: "incentivize.erlang",
  key_separator: ".",
  interval: 1_000
)

config :incentivize, :stellar_module, Incentivize.Stellar
config :incentivize, :github_repos_module, Incentivize.Github.API.Repos
config :incentivize, :nodejs, timeout: 60_000

config :incentivize, :stellar_asset,
  code: "XLM",
  issuer: nil

config :rihanna, dispatcher_max_concurrency: 1

config :stellar, network: :test

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
