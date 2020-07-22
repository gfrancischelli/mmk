defmodule Mmk.Core.Game do
  defstruct ~w[score current_stage teams current_team current_player words word_pool current_word winner]a

  alias Mmk.Core.{Game, Score}

  def new(teams, words) do
    current_word = Enum.random(words)
    words = List.delete(words, current_word)

    %__MODULE__{
      winner: nil,
      teams: teams,
      current_team: :alpha,
      current_player: %{alpha: 0, beta: 0},
      words: MapSet.new(words),
      word_pool: MapSet.new(words),
      current_word: current_word,
      current_stage: :many_words,
      score: %{one_word: Score.new(), mimic: Score.new(), many_words: Score.new()}
    }
  end

  def guess_word(%Game{current_word: word} = game, guess) when guess == word,
    do: guess_right(game)

  def guess_word(game, _word), do: game

  defp guess_right(game) do
    game
    |> move_current_word_to_score()
    |> next_player()
    |> select_random_word()
    |> maybe_advance_stage()
    |> maybe_add_winner()
  end

  defp maybe_add_winner(%Game{current_stage: :finished} = game) do
    game
    |> Map.put(:winner, Score.get_winner(game.score))
  end

  defp maybe_add_winner(game), do: game

  defp maybe_advance_stage(%Game{current_word: word} = game) when is_binary(word), do: game

  defp maybe_advance_stage(%Game{words: words} = game) do
    if MapSet.size(words) > 0,
      do: game,
      else: maybe_advance_stage(game, :advance)
  end

  defp maybe_advance_stage(%Game{} = game, :advance) do
    stage =
      case game.current_stage do
        :many_words -> :mimic
        :mimic -> :one_word
        :one_word -> :finished
      end

    game
    |> Map.put(:current_stage, stage)
    |> Map.put(:words, game.word_pool)
    |> reset_words()
  end

  defp reset_words(game), do: Map.put(game, :words, game.word_pool)

  defp move_current_word_to_score(%Game{current_word: word} = game) when not is_binary(word),
    do: game

  defp move_current_word_to_score(%Game{current_team: team, current_word: word} = game) do
    %Game{current_stage: stage, score: score} = game

    stage_score = Map.get(score, stage)

    score = Map.put(score, stage, Score.add_word(stage_score, team, word))

    game
    |> Map.put(:score, score)
    |> Map.put(:current_word, nil)
  end

  def select_random_word(%Game{words: words} = game) do
    cond do
      MapSet.size(words) == 0 ->
        game

      true ->
        rand_word = Enum.random(game.words)
        words = MapSet.delete(words, rand_word)

        game
        |> Map.put(:words, words)
        |> Map.put(:current_word, rand_word)
    end
  end

  def next_team(%Game{current_team: :alpha} = game), do: Map.put(game, :current_team, :beta)
  def next_team(%Game{current_team: :beta} = game), do: Map.put(game, :current_team, :alpha)

  defp next_player(%Mmk.Core.Game{current_team: team} = game) do
    %{^team => index} = game.current_player

    next_index =
      if index + 1 == length(game.teams[team]) do
        0
      else
        index + 1
      end

    next_player = game.current_player |> Map.put(team, next_index)

    game
    |> Map.put(:current_player, next_player)
  end
end
