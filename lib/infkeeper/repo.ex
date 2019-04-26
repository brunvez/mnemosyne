defmodule Infkeeper.Repo do
  use Ecto.Repo,
    otp_app: :infkeeper,
    adapter: Ecto.Adapters.Postgres
end
