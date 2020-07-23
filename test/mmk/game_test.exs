defmodule GameTest do
  use ExUnit.Case
  use GameBuilder

  test "a fresh game starts with first player from alpha team" do
    game = build_game()
    assert :alpha == game.current_team
    assert %{alpha: 0} = game.current_player
  end

  test "guessing a word wrong will mark last guess as wrong" do
    game = build_game()

    assert Game.guess_word(game, "x") == %Game{game | last_guess: :incorrect}
  end

  test "select_random_word advances to a next random word when available" do
    game = build_game()
    next = Game.select_random_word(game)

    assert game.current_word != next.current_word
  end

  test "select_random_word don't advances when there is only one word" do
    game = build_game(["a"])
    next = Game.select_random_word(game)

    assert game.current_word == "a"
    assert game.current_word == next.current_word
  end

  describe "guessing a word right" do
    setup [:guess_right]

    test "moves the word to the round score", %{game: game, word: word, team: team} do
      score =
        game.score
        |> Map.fetch!(game.current_stage)
        |> Map.fetch!(team)

      assert MapSet.member?(score, word)
    end

    test "selects a new random word", %{game: game, word: word} do
      new_word = Map.fetch!(game, :current_word)
      assert new_word != word
      assert new_word != nil
      assert MapSet.member?(game.words, new_word) == false
    end

    test "advanced round or end game when it was  the last word" do
      game = build_game(["a", "b"])
      new_game = Game.guess_word(game, game.current_word)

      assert new_game.current_stage == :many_words
      assert MapSet.size(new_game.words) == 0

      new_game = Game.guess_word(new_game, new_game.current_word)

      assert new_game.current_stage == :mimic
      assert MapSet.size(new_game.words) == 1

      # Guess right the 2 words
      new_game = Game.guess_word(new_game, new_game.current_word)
      new_game = Game.guess_word(new_game, new_game.current_word)

      assert new_game.current_stage == :one_word
      assert MapSet.size(new_game.words) == 1

      # Guess right the 2 words
      new_game = Game.guess_word(new_game, new_game.current_word)
      new_game = Game.guess_word(new_game, new_game.current_word)

      assert new_game.current_stage == :finished
      assert new_game.winner == new_game.current_team
    end
  end

  defp guess_right(ctx) do
    game = build_game()
    %{current_team: team, current_word: word} = game

    {:ok,
     ctx
     |> Map.put(:word, word)
     |> Map.put(:team, team)
     |> Map.put(:game, Game.guess_word(game, word))}
  end
end
