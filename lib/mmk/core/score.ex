defmodule Mmk.Core.Score do
  defstruct alpha: MapSet.new(), beta: MapSet.new()

  def new do
    struct!(__MODULE__)
  end

  def add_word(score, team, word) do
    new_score = Map.fetch!(score, team) |> MapSet.put(word)

    Map.put(score, team, new_score)
  end

  def get_winner(score) do
    beta = get_team_score(score, :beta)
    alpha = get_team_score(score, :alpha)

    if alpha > beta, do: :alpha, else: :beta
  end

  @spec get_team_score(any, any) :: number
  def get_team_score(score, team) do
    score
    |> Enum.to_list()
    |> Enum.map(&score_tuple_to_points(&1, team))
    |> Enum.sum()
  end

  defp score_tuple_to_points(score_tuple, team) do
    score_tuple
    |> elem(1)
    |> Map.fetch!(team)
    |> MapSet.size()
  end
end
