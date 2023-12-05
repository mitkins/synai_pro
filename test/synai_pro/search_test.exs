defmodule SynaiPro.SearchTest do
  use SynaiPro.DataCase

  alias SynaiPro.Search

  describe "embeddings" do
    alias SynaiPro.Search.Embedding

    import SynaiPro.SearchFixtures

    @invalid_attrs %{tokens: nil, title: nil, url: nil, content: nil, embedding: nil}

    test "list_embeddings/0 returns all embeddings" do
      embedding = embedding_fixture()
      assert Search.list_embeddings() == [embedding]
    end

    test "get_embedding!/1 returns the embedding with given id" do
      embedding = embedding_fixture()
      assert Search.get_embedding!(embedding.id) == embedding
    end

    test "create_embedding/1 with valid data creates a embedding" do
      valid_attrs = %{tokens: 42, title: "some title", url: "some url", content: "some content", embedding: "some embedding"}

      assert {:ok, %Embedding{} = embedding} = Search.create_embedding(valid_attrs)
      assert embedding.tokens == 42
      assert embedding.title == "some title"
      assert embedding.url == "some url"
      assert embedding.content == "some content"
      assert embedding.embedding == "some embedding"
    end

    test "create_embedding/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Search.create_embedding(@invalid_attrs)
    end

    test "update_embedding/2 with valid data updates the embedding" do
      embedding = embedding_fixture()
      update_attrs = %{tokens: 43, title: "some updated title", url: "some updated url", content: "some updated content", embedding: "some updated embedding"}

      assert {:ok, %Embedding{} = embedding} = Search.update_embedding(embedding, update_attrs)
      assert embedding.tokens == 43
      assert embedding.title == "some updated title"
      assert embedding.url == "some updated url"
      assert embedding.content == "some updated content"
      assert embedding.embedding == "some updated embedding"
    end

    test "update_embedding/2 with invalid data returns error changeset" do
      embedding = embedding_fixture()
      assert {:error, %Ecto.Changeset{}} = Search.update_embedding(embedding, @invalid_attrs)
      assert embedding == Search.get_embedding!(embedding.id)
    end

    test "delete_embedding/1 deletes the embedding" do
      embedding = embedding_fixture()
      assert {:ok, %Embedding{}} = Search.delete_embedding(embedding)
      assert_raise Ecto.NoResultsError, fn -> Search.get_embedding!(embedding.id) end
    end

    test "change_embedding/1 returns a embedding changeset" do
      embedding = embedding_fixture()
      assert %Ecto.Changeset{} = Search.change_embedding(embedding)
    end
  end
end
