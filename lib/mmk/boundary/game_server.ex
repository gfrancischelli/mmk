defmodule Mmk.Boundary.GameServer do
  alias Mmk.Core.{Game}

  use GenServer

  @timeout :timer.hours(1)

  def start_link(name, teams, words) do
    GenServer.start_link(__MODULE__, {teams, words}, name: via(name))
  end

  def init({teams, words}) do
    game = Game.new(teams, words)
    {:ok, game, @timeout}
  end

  # Public Api

  def guess_word(session, word) do
    GenServer.call(session, {:guess_word, word})
  end

  def summary(name) do
    GenServer.call(via(name), :summary)
  end

  # Private Functions

  defp maybe_finish(%Game{winner: winner}) when not is_nil(winner) do
    {:stop, :normal, {:winner, winner}, nil}
  end

  defp maybe_finish(game) do
    team = game.current_team
    player = game.current_player[team]
    {:reply, %{team: team, player: player, last_guess: game.last_guess}, game}
  end

  # Callbacks

  def handle_call(:summary, _from, game) do
    {:reply, summarize(game), game, @timeout}
  end

  def handle_call({:guess_word, word}, _from, game) do
    game
    |> Game.guess_word(word)
    |> maybe_finish()
  end

  def handle_info(:timeout, game) do
    {:stop, {:shotdown, :timeout}, game}
  end

  def terminate({:shutdown, :timeout}, _game) do
    :ok
  end

  def summarize(game) do
    %{
      teams: game.teams,
      score: game.score,
      words: game.word_pool
    }
  end

  def via(name) do
    {:via, Registry, {Mmk.GameRegistry, name}}
  end

  def game_pid(name) do
    name
    |> via()
    |> GenServer.whereis()
  end
end
