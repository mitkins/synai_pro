defmodule SynaiPro.Repo.Migrations.CreateEmbeddings do
  use Ecto.Migration

  def change do
    create table(:embeddings) do
      add :title, :text
      add :url, :text
      add :content, :text
      add :tokens, :integer
      add :embedding, :vector

      timestamps()
    end
  end
end
