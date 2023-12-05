defmodule SynaiPro.Repo do
  use Ecto.Repo,
    otp_app: :synai_pro,
    adapter: Ecto.Adapters.Postgres

  use PetalFramework.Extensions.Ecto.RepoExt
end
