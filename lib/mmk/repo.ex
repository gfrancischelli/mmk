defmodule Mmk.Repo do
  use Ecto.Repo,
    otp_app: :mmk,
    adapter: Ecto.Adapters.Postgres
end
