defmodule SynaiProWeb.EmbeddingLive.Index do
  use SynaiProWeb, :live_view

  alias SynaiPro.Search
  alias SynaiPro.Search.Embedding
  alias PetalFramework.Components.DataTable

  @data_table_opts [
    default_limit: 10,
    default_order: %{
      order_by: [:id, :inserted_at],
      order_directions: [:asc, :asc]
    },
    sortable: [:id, :inserted_at, :title, :url, :content, :tokens, :embedding],
    filterable: [:id, :inserted_at, :title, :url, :content, :tokens, :embedding]
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, index_params: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Embedding")
    |> assign(:embedding, Search.get_embedding!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Embedding")
    |> assign(:embedding, %Embedding{})
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Embeddings")
    |> assign_embeddings(params)
    |> assign(index_params: params)
  end

  defp current_index_path(index_params) do
    ~p"/embeddings?#{index_params || %{}}"
  end

  @impl true
  def handle_event("update_filters", params, socket) do
    query_params = DataTable.build_filter_params(socket.assigns.meta.flop, params)
    {:noreply, push_patch(socket, to: ~p"/embeddings?#{query_params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    embedding = Search.get_embedding!(id)
    {:ok, _} = Search.delete_embedding(embedding)

    socket =
      socket
      |> assign_embeddings(socket.assigns.index_params)
      |> put_flash(:info, "Embedding deleted")

    {:noreply, socket}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: current_index_path(socket.assigns.index_params))}
  end

  defp assign_embeddings(socket, params) do
    starting_query = Embedding
    {embeddings, meta} = DataTable.search(starting_query, params, @data_table_opts)
    assign(socket, embeddings: embeddings, meta: meta)
  end
end
