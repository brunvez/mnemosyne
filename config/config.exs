# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :infkeeper,
  ecto_repos: [Infkeeper.Repo]

# Configures the endpoint
config :infkeeper, InfkeeperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QZDeYd2HIzUFCuFGAgRWW6lkcDq6qNtDHX5tT9W3TBwna9TrmHU62Qn3uSzzoO6Y",
  render_errors: [view: InfkeeperWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Infkeeper.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
