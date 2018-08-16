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
  pubsub: [name: Incentivize.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :incentivize, Incentivize.Github.OAuth,
  client_id: {:system, "GITHUB_CLIENT_ID"},
  client_secret: {:system, "GITHUB_CLIENT_SECRET"}

config :incentivize, Incentivize.Stellar,
  # Defaults to test network
  network_url: {:system, "STELLAR_NETWORK_URL", "https://horizon-testnet.stellar.org"},
  public_key: {:system, "STELLAR_PUBLIC_KEY"},
  secret: {:system, "STELLAR_SECRET"}

config :rollbax,
  enabled: false,
  environment: "dev"

config :incentivize, :stellar_module, Incentivize.Stellar
config :incentivize, :nodejs, timeout: {:system, :integer, "NODEJS_TIMEOUT", 60_000}

config :rihanna, dispatcher_max_concurrency: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
