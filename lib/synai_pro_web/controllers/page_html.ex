defmodule SynaiProWeb.PageHTML do
  use SynaiProWeb, :html
  alias SynaiProWeb.Components.LandingPage

  embed_templates "page_html/*"
end
