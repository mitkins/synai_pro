defmodule SynaiProWeb.AuthImpersonationRoutes do
  defmacro __using__(_) do
    quote do
      scope "/auth", SynaiProWeb do
        pipe_through [:browser, :require_admin_user]

        post "/impersonate", UserImpersonationController, :create
      end

      scope "/auth", SynaiProWeb do
        pipe_through [:browser, :require_authenticated_user]

        delete "/impersonate", UserImpersonationController, :delete
      end
    end
  end
end
