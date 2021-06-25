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

config :task_3,
  professions_csv: "technical-test-professions.csv",
  jobs_csv: "technical-test-jobs.csv",
  result_map: %{
    "Europe" => [],
    "Asia" => [],
    "Africa" => [],
    "Oceania" => [],
    "South America" => [],
    "North America" => [],
    "Antarctica" => []
  },
  continents: [
    {"Europe", 60, 15},
    {"Asia", 53, 103},
    {"Africa", 1, 15},
    {"Oceania", 18, 160},
    {"South America", 26, 60},
    {"North America", 48, 108},
    {"Antarctica", 0, 75}
  ],
  earth_radius: 6371

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
