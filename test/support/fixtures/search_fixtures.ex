defmodule SynaiPro.SearchFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SynaiPro.Search` context.
  """

  @doc """
  Generate a embedding.
  """
  def embedding_fixture(attrs \\ %{}) do
    {:ok, embedding} =
      attrs
      |> Enum.into(%{
        content: "some content",
        embedding: "some embedding",
        title: "some title",
        tokens: 42,
        url: "some url"
      })
      |> SynaiPro.Search.create_embedding()

    embedding
  end
end
