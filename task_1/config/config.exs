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
    {"Europe", [{-5, 37}, {-7, 75}, {61, 52}, {66, 76}]},
    {"Asia", [{44, 15}, {26, 39}, {169, 78}, {105, -1}]},
    {"Africa", [{-17, 35}, {-16, -35}, {45, 32}, {22, 35}]},
    {"Oceania", [{103, -8}, {106, -43}, {174, -45}, {172, 3}]},
    {"South America", [{-95, 10}, {-85, -55}, {-102, 8}, {-32, 12}]},
    {"North America", [{-85, 2}, {-171, 63}, {-66, 75}, {-69, 12}]}
  ]
