defmodule Mmk.Boundary.GameValidator do
  def teams(%{alpha: alpha, beta: beta}) when is_list(alpha) and is_list(beta) do
    :ok
  end

  def teams(%{beta: _}), do: {:error, "missing team alpha"}
  def teams(%{alpha: _}), do: {:error, "missing team beta"}
  def teams(_), do: {:error, "missing teams alpha and beta"}

  def words(words) when is_list(words) and length(words) > 0, do: :ok
  def words(_), do: {:error, "missing words list"}
end
