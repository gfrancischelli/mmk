# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mmk,
  ecto_repos: [Mmk.Repo]

# Configures the endpoint
config :mmk, MmkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oAKBK/fLkOnELkWIf9vVGGFKcjY4rhQy4CUX0UDPvUtLdL8uobyW9Q0bCGgfpux3",
  render_errors: [view: MmkWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mmk.PubSub,
  live_view: [signing_salt: "1acIvGpu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
