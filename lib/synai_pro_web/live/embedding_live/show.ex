defmodule SynaiProWeb.EmbeddingLive.Show do
  use SynaiProWeb, :live_view

  alias SynaiPro.Search

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:embedding, Search.get_embedding!(id))}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/embeddings/#{socket.assigns.embedding}")}
  end

  defp page_title(:show), do: "Show Embedding"
  defp page_title(:edit), do: "Edit Embedding"
end
