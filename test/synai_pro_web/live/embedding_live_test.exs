defmodule SynaiProWeb.EmbeddingLiveTest do
  use SynaiProWeb.ConnCase

  import Phoenix.LiveViewTest
  import SynaiPro.SearchFixtures

  @create_attrs %{tokens: 42, title: "some title", url: "some url", content: "some content", embedding: "some embedding"}
  @update_attrs %{tokens: 43, title: "some updated title", url: "some updated url", content: "some updated content", embedding: "some updated embedding"}
  @invalid_attrs %{tokens: nil, title: nil, url: nil, content: nil, embedding: nil}

  defp create_embedding(_) do
    embedding = embedding_fixture()
    %{embedding: embedding}
  end

  describe "Index" do
    setup [:create_embedding]

    test "lists all embeddings", %{conn: conn, embedding: embedding} do
      {:ok, _index_live, html} = live(conn, ~p"/embeddings")

      assert html =~ "Listing Embeddings"
      assert html =~ embedding.title
    end

    test "saves new embedding", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/embeddings")

      assert index_live |> element("a", "New Embedding") |> render_click() =~
               "New Embedding"

      assert_patch(index_live, ~p"/embeddings/new")

      assert index_live
             |> form("#embedding-form", embedding: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#embedding-form", embedding: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/embeddings")

      assert html =~ "Embedding created successfully"
      assert html =~ "some title"
    end

    test "updates embedding in listing", %{conn: conn, embedding: embedding} do
      {:ok, index_live, _html} = live(conn, ~p"/embeddings")

      assert index_live |> element("a[href='/embeddings/#{embedding.id}/edit']", "Edit") |> render_click() =~
               "Edit Embedding"

      assert_patch(index_live, ~p"/embeddings/#{embedding}/edit")

      assert index_live
             |> form("#embedding-form", embedding: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#embedding-form", embedding: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/embeddings")

      assert html =~ "Embedding updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes embedding in listing", %{conn: conn, embedding: embedding} do
      {:ok, index_live, _html} = live(conn, ~p"/embeddings")

      assert index_live |> element("a[phx-value-id=#{embedding.id}]", "Delete") |> render_click()
      refute has_element?(index_live, "a[phx-value-id=#{embedding.id}]")
    end
  end

  describe "Show" do
    setup [:create_embedding]

    test "displays embedding", %{conn: conn, embedding: embedding} do
      {:ok, _show_live, html} = live(conn, ~p"/embeddings/#{embedding}")

      assert html =~ "Show Embedding"
      assert html =~ embedding.title
    end

    test "updates embedding within modal", %{conn: conn, embedding: embedding} do
      {:ok, show_live, _html} = live(conn, ~p"/embeddings/#{embedding}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Embedding"

      assert_patch(show_live, ~p"/embeddings/#{embedding}/show/edit")

      assert show_live
             |> form("#embedding-form", embedding: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#embedding-form", embedding: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/embeddings/#{embedding}")

      assert html =~ "Embedding updated successfully"
      assert html =~ "some updated title"
    end
  end
end
