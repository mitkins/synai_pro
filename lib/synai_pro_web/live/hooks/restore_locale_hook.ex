defmodule SynaiProWeb.RestoreLocaleHook do
  def on_mount(:default, _params, %{"locale" => locale} = _session, socket)
      when is_binary(locale) do
    Gettext.put_locale(SynaiProWeb.Gettext, locale)
    {:cont, socket}
  end

  def on_mount(:default, _params, _session, socket), do: {:cont, socket}
end
