defmodule Mmk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Mmk.GameRegistry},
      Mmk.Boundary.GameSupervisor,
      # Start the Ecto repository
      Mmk.Repo,
      # Start the Telemetry supervisor
      MmkWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mmk.PubSub},
      # Start the Endpoint (http/https)
      MmkWeb.Endpoint
      # Start a worker by calling: Mmk.Worker.start_link(arg)
      # {Mmk.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mmk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MmkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
