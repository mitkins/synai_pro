defmodule SynaiProWeb.EmbeddingLive.FormComponent do
  use SynaiProWeb, :live_component

  alias SynaiPro.Search

  @impl true
  def update(%{embedding: embedding} = assigns, socket) do
    changeset = Search.change_embedding(embedding)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"embedding" => embedding_params}, socket) do
    changeset =
      socket.assigns.embedding
      |> Search.change_embedding(embedding_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"embedding" => embedding_params}, socket) do
    save_embedding(socket, socket.assigns.action, embedding_params)
  end

  defp save_embedding(socket, :edit, embedding_params) do
    case Search.update_embedding(socket.assigns.embedding, embedding_params) do
      {:ok, _embedding} ->
        {:noreply,
         socket
         |> put_flash(:info, "Embedding updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_embedding(socket, :new, embedding_params) do
    case Search.create_embedding(embedding_params) do
      {:ok, _embedding} ->
        {:noreply,
         socket
         |> put_flash(:info, "Embedding created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
