# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :scaffolding,
  ecto_repos: [Scaffolding.Repo]

# Configures the endpoint
config :scaffolding, Scaffolding.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qJx4dcR7Y2lYowZ4pO+oLWaQ4hQ52lEThehPajXyEiLlYyBXwBx9Iz1D/V1EtvCx",
  render_errors: [view: Scaffolding.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Scaffolding.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
