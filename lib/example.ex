defmodule Mmk.Example do
  def get() do
    teams = %{alpha: ["a1", "a2"], beta: ["b1", "b2"]}
    words = ["a", "b"]
    {teams, words}
  end
end
