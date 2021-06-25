# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :task_3, Task3Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7gWaH1c040i2shFA1ebpppZTqT0vLpNW+aPXiYlB0czG7k4Rl4YJNuDUy7tU/bX+",
  render_errors: [view: Task3Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Task3.PubSub,
  live_view: [signing_salt: "g9LUBLGQ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
