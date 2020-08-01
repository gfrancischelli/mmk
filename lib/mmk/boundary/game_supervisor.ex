defmodule Mmk.Boundary.GameSupervisor do
  alias Mmk.Boundary.GameServer

  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_game(name, teams, words) do
    child_spec = %{
      id: GameServer,
      start: {GameServer, :start_link, [name, teams, words]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
