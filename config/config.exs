# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :example_live_view_app,
  ecto_repos: [ExampleLiveViewApp.Repo]

# Configures the endpoint
config :example_live_view_app, ExampleLiveViewAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5zLaGc8q/3tsx8JgTTc1MXl7eqLUA0tWj4OJDy88OA1tsA3G0oGix+nTFcWhGWaB",
  render_errors: [view: ExampleLiveViewAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExampleLiveViewApp.PubSub,
  live_view: [signing_salt: "k6t3DSCZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
