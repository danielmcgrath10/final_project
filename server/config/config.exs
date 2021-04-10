# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :final_project,
  ecto_repos: [FinalProject.Repo]

# Configures the endpoint
config :final_project, FinalProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hnKBv2LXQpj7VSdNgEAC9zRg56d+Hpatk74NlRPFx7a4vP8UioxeLrexgiixu+GG",
  render_errors: [view: FinalProjectWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FinalProject.PubSub,
  live_view: [signing_salt: "bKFGqM46"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :cors_plug,
  origin: ["http://localhost:3000"],
  max_age: 86400,
  methods: ["GET", "POST", "PATCH", "DELETE"]
