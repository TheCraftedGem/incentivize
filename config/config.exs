# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :Incentivize,
  ecto_repos: [incentivize.Repo]

# Configures the endpoint
config :Incentivize, incentivizeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2ICx98yJO4b08TwDLYwn4iFDWkxDwOqzCR6wyk0O1giiPBr3MvI9ySwg6o7dKeeu",
  render_errors: [view: incentivizeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: incentivize.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
