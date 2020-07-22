Code.require_file("support/game_builder.exs", __DIR__)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Mmk.Repo, :manual)
