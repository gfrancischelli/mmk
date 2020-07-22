defmodule GameBuilder do
  defmacro __using__(_options) do
    quote do
      alias Mmk.Core.{Game}
      import GameBuilder, only: :functions
    end
  end

  alias Mmk.Core.{Game}

  def build_game(words \\ ["a", "b", "c", "d"]) do
    teams = %{alpha: ["a1", "a2"], beta: ["b1", "b2"]}
    Game.new(teams, words)
  end
end
