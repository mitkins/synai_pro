defmodule SynaiPro.Search do
  @moduledoc """
  The Search context.
  """

  import Ecto.Query, warn: false
  alias SynaiPro.Repo

  alias SynaiPro.Search.Embedding

  import Pgvector.Ecto.Query

@doc """
  Returns the list of embeddings.

  ## Examples

      iex> list_embeddings()
      [%Embedding{}, ...]

  """
  def list_embeddings do
    Repo.all(Embedding)
  end

  @doc """
  Gets a single embedding.

  Raises `Ecto.NoResultsError` if the Embedding does not exist.

  ## Examples

      iex> get_embedding!(123)
      %Embedding{}

      iex> get_embedding!(456)
      ** (Ecto.NoResultsError)

  """
  def get_embedding!(id), do: Repo.get!(Embedding, id)

  @doc """
  Creates a embedding.

  ## Examples

      iex> create_embedding(%{field: value})
      {:ok, %Embedding{}}

      iex> create_embedding(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_embedding(attrs \\ %{}) do
    %Embedding{}
    |> Embedding.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a embedding.

  ## Examples

      iex> update_embedding(embedding, %{field: new_value})
      {:ok, %Embedding{}}

      iex> update_embedding(embedding, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_embedding(%Embedding{} = embedding, attrs) do
    embedding
    |> Embedding.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a embedding.

  ## Examples

      iex> delete_embedding(embedding)
      {:ok, %Embedding{}}

      iex> delete_embedding(embedding)
      {:error, %Ecto.Changeset{}}

  """
  def delete_embedding(%Embedding{} = embedding) do
    Repo.delete(embedding)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking embedding changes.

  ## Examples

      iex> change_embedding(embedding)
      %Ecto.Changeset{data: %Embedding{}}

  """
  def change_embedding(%Embedding{} = embedding, attrs \\ %{}) do
    Embedding.changeset(embedding, attrs)
  end

  def get_top3_similar_docs(embeddings) do
    Repo.all(from i in Embedding, order_by: l2_distance(i.embedding, ^embeddings), limit: 3)
  end
end
