defmodule SynaiProWeb.PageController do
  use SynaiProWeb, :controller

  def landing_page(conn, _params) do
    render(conn, :landing_page, page_title: gettext("Home"))
  end

  def license(conn, _params) do
    render(conn, :license, page_title: gettext("License"))
  end

  def privacy(conn, _params) do
    render(conn, :privacy, page_title: gettext("Privacy"))
  end
end
