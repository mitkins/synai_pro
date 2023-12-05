defmodule SynaiProWeb.CheckConfigPlug do
  import Plug.Conn
  use Phoenix.Controller

  def init(options), do: options

  def call(conn, opts) do
    if SynaiPro.config(opts[:config_key]) do
      conn
    else
      conn
      |> redirect(to: opts[:else])
      |> halt()
    end
  end
end
