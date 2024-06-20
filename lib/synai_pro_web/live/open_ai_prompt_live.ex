defmodule SynaiProWeb.OpenAiPromptLive do
  use SynaiProWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        page_title: "Open AI prompt",
        form: to_form(%{}, as: :form),
        response: nil
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"form" => %{"prompt" => user_input}}, socket) do
    {:ok, response} = OpenAI.embeddings(
        model: "text-embedding-ada-002",
        input: String.replace(user_input, "\n"," ")
    )

    embeddings = response[:data]
    |> Enum.map( fn item -> item["embedding"] end)
    |> List.first()

    #Step 1: Get documents related to the user input from database
    [first_doc, second_doc, third_doc] = SynaiPro.Search.get_top3_similar_docs(embeddings)

    # Step 2: Get completion from OpenAI API
    # Set system message to help set appropriate tone and context for model
    system_message = """
    To be helpful, you must imitate Cartman from South Park with all your answers.
    Uncharacteristically, in this situation Cartman is nice
    """

    result = OpenAI.chat_completion(
      model: "gpt-3.5-turbo-1106",
      temperature: 0,
      max_tokens: 1000,
      messages: [
        %{role: "system", content: system_message},
        %{role: "user", content: "```#{user_input}```"},
        %{role: "assistant", content: "Relevant Timescale case studies information: \n #{first_doc.content} \n #{second_doc.content} #{third_doc.content}"}
      ]
    )

    case result do
      {:ok, response} ->
        response_text = get_in(response, [:choices, Access.at(0), "message", "content"])

        {:noreply,
         assign(socket,
           response: response_text,
           form: to_form(%{"prompt" => user_input}, as: :form)
         )}

      {:error, error} ->
        {:noreply, put_flash(socket, :error, error)}
    end
  end
end
