defmodule SynaiProWeb.Router do
  use SynaiProWeb, :router
  import SynaiProWeb.UserAuth
  import SynaiProWeb.OrgPlugs
  import Phoenix.LiveDashboard.Router
  alias SynaiProWeb.OnboardingPlug
  import SynaiProWeb.UserImpersonationController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SynaiProWeb.Layouts, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "content-security-policy" =>
        ContentSecurityPolicy.serialize(
          struct(ContentSecurityPolicy.Policy, SynaiPro.config(:content_security_policy))
        )
    }

    plug :fetch_current_user
    plug :fetch_impersonator_user
    plug :kick_user_if_suspended_or_deleted
    plug PetalFramework.SetLocalePlug, gettext: SynaiProWeb.Gettext
  end

  pipeline :public_layout do
    plug :put_layout, html: {SynaiProWeb.Layouts, :public}
  end

  pipeline :authenticated do
    plug :require_authenticated_user
    plug OnboardingPlug
    plug :assign_org_data
  end

  # Public routes
  scope "/", SynaiProWeb do
    pipe_through [:browser, :public_layout]

    # Add public controller routes here
    get "/", PageController, :landing_page
    get "/privacy", PageController, :privacy
    get "/license", PageController, :license

    live_session :public, layout: {SynaiProWeb.Layouts, :public} do
      # Add public live routes here

      live "/embeddings", EmbeddingLive.Index, :index
      live "/embeddings/new", EmbeddingLive.Index, :new
      live "/embeddings/:id/edit", EmbeddingLive.Index, :edit

      live "/embeddings/:id", EmbeddingLive.Show, :show
      live "/embeddings/:id/show/edit", EmbeddingLive.Show, :edit
    end
  end

  # App routes - for signed in and confirmed users only
  scope "/app", SynaiProWeb do
    pipe_through [:browser, :authenticated]

    # Add controller authenticated routes here
    put "/users/settings/update-password", UserSettingsController, :update_password
    get "/users/settings/confirm-email/:token", UserSettingsController, :confirm_email
    get "/users/totp", UserTOTPController, :new
    post "/users/totp", UserTOTPController, :create

    live_session :authenticated,
      on_mount: [
        {SynaiProWeb.UserOnMountHooks, :require_authenticated_user},
        {SynaiProWeb.OrgOnMountHooks, :assign_org_data}
      ] do
      # Add live authenticated routes here
      live "/", DashboardLive
      live "/users/onboarding", UserOnboardingLive
      live "/users/edit-profile", EditProfileLive
      live "/users/edit-email", EditEmailLive
      live "/users/change-password", EditPasswordLive
      live "/users/edit-notifications", EditNotificationsLive
      live "/users/org-invitations", UserOrgInvitationsLive
      live "/users/two-factor-authentication", EditTotpLive

      live "/orgs", OrgsLive, :index
      live "/orgs/new", OrgsLive, :new

      scope "/org/:org_slug" do
        live "/", OrgDashboardLive
        live "/edit", EditOrgLive
        live "/team", OrgTeamLive, :index
        live "/team/invite", OrgTeamLive, :invite
        live "/team/memberships/:id/edit", OrgTeamLive, :edit_membership
      end
    end
  end

  use SynaiProWeb.AuthRoutes

  if SynaiPro.config(:impersonation_enabled?) do
    use SynaiProWeb.AuthImpersonationRoutes
  end

  use SynaiProWeb.MailblusterRoutes
  use SynaiProWeb.AdminRoutes

  # DevRoutes must always be last
  use SynaiProWeb.DevRoutes
end
