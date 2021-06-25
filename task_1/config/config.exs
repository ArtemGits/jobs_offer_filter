# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :task_1,
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
    {"Oceania", -18, 160},
    {"South America", -26, -60},
    {"North America", 48, -108},
    {"Antarctica", -75, 0}
  ]

