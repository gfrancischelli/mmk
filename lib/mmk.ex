defmodule Mmk do
  alias Mmk.Core.Game
  alias Mmk.Boundary.{GameSession, GameValidator}

  def new_game(teams, words) do
    with :ok <- GameValidator.teams(teams),
         :ok <- GameValidator.words(words),
         game <- Game.new(teams, words),
         {:ok, session} <- GenServer.start_link(GameSession, game) do
      session
    else
      error -> error
    end
  end

  def guess_word(session, word) when is_binary(word) do
    GenServer.call(session, {:guess_word, word})
  end

  def guess_word(_, _), do: {:error, "word must be a string"}
end
