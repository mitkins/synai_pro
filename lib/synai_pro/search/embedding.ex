defmodule SynaiPro.Search.Embedding do
  use Ecto.Schema
  import Ecto.Changeset

  schema "embeddings" do
    field :tokens, :integer
    field :title, :string
    field :url, :string
    field :content, :string
    field :embedding, Pgvector.Ecto.Vector

    timestamps()
  end

  @doc false
  def changeset(embedding, attrs) do
    embedding
    |> cast(attrs, [:title, :url, :content, :tokens, :embedding])
    |> validate_required([:title, :url, :content, :tokens, :embedding])
  end
end
