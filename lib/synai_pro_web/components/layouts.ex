defmodule SynaiProWeb.Layouts do
  use SynaiProWeb, :html
  alias SynaiProWeb.Components.LandingPage

  embed_templates "layouts/*"

  require Logger

  def app_name, do: SynaiPro.config(:app_name)

  def title(%{assigns: %{page_title: page_title}}), do: page_title

  def title(conn) do
    if is_public_page(conn.request_path) do
      Logger.warning(
        "Warning: no title defined for path #{conn.request_path}. Defaulting to #{app_name()}. Assign `page_title` in controller action or live view mount to fix."
      )
    end

    app_name()
  end

  def description(%{assigns: %{meta_description: meta_description}}), do: meta_description

  def description(conn) do
    if conn.request_path == "/" do
      SynaiPro.config(:seo_description)
    else
      if is_public_page(conn.request_path) do
        Logger.warning(
          "Warning: no meta description for public path #{conn.request_path}. Assign `meta_description` in controller action or live view mount to fix."
        )
      end

      ""
    end
  end

  def og_image(%{assigns: %{og_image: og_image}}), do: og_image
  def og_image(_conn), do: url(~p"/images/open-graph.png")

  def og_image_width(%{assigns: %{og_image_width: og_image_width}}), do: og_image_width
  def og_image_width(_conn), do: "1200"

  def og_image_height(%{assigns: %{og_image_height: og_image_height}}), do: og_image_height
  def og_image_height(_conn), do: "630"

  def og_image_type(%{assigns: %{og_image_type: og_image_type}}), do: og_image_type
  def og_image_type(_conn), do: "image/png"

  def current_page_url(%{request_path: request_path}),
    do: SynaiProWeb.Endpoint.url() <> request_path

  def current_page_url(_conn), do: SynaiProWeb.Endpoint.url()

  def twitter_creator(%{assigns: %{twitter_creator: twitter_creator}}), do: twitter_creator
  def twitter_creator(_conn), do: twitter_site(%{})

  def twitter_site(%{assigns: %{twitter_site: twitter_site}}), do: twitter_site

  def twitter_site(_conn) do
    if SynaiPro.config(:twitter_url) do
      "@" <> (SynaiPro.config(:twitter_url) |> String.split("/") |> List.last())
    else
      ""
    end
  end

  def is_public_page(request_path) do
    stripped_path = URI.parse(request_path).path

    Enum.find(SynaiProWeb.Menus.public_menu_items(), &(URI.parse(&1.path).path == stripped_path))
  end
end
