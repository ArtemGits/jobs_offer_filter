defmodule Task3.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Task3Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Task3.PubSub},
      # Start the Endpoint (http/https)
      Task3Web.Endpoint
      # Start a worker by calling: Task3.Worker.start_link(arg)
      # {Task3.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Task3.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Task3Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
