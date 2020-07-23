defmodule Mmk.Boundary.GameSession do
  alias Mmk.Core.{Game}
  use GenServer

  # GenServer Callbacks

  def init(game) do
    {:ok, game}
  end

  def handle_call({:guess_word, word}, _from, game) do
    game
    |> Game.guess_word(word)
    |> maybe_finish()
  end

  # Public Api

  def guess_word(session, word) do
    GenServer.call(session, {:guess_word, word})
  end

  # Private Implementation

  defp maybe_finish(%Game{winner: winner}) when not is_nil(winner) do
    {:stop, :normal, {:winner, winner}, nil}
  end

  defp maybe_finish(game) do
    team = game.current_team
    player = game.current_player[team]
    {:reply, %{team: team, player: player, last_guess: game.last_guess}, game}
  end
end
