defmodule PingCRM.Web.Router do
  use PingCRM.Web, :router

  import PingCRM.Web.UserAuth
  import PingCRM.Web.Inertia

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_previous_url
    plug :put_layout, html: {PingCRM.Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Combo.Vite.Plug
    plug Combo.Inertia.Plug
    plug :fetch_current_user
    plug :put_inertia_share
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PingCRM.Web do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/login", UserSessionController, :show
    post "/login", UserSessionController, :create
  end

  scope "/", PingCRM.Web do
    pipe_through [:browser, :require_authenticated_user]

    get "/", DashboardController, :index

    get "/profile", ProfileController, :edit
    put "/profile", ProfileController, :update

    get "/users", UserController, :index
    get "/users/new", UserController, :new
    post "/users", UserController, :create
    get "/users/:id/edit", UserController, :edit
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete
    put "/users/:id/restore", UserController, :restore

    get "/orgs", OrgController, :index
    get "/orgs/new", OrgController, :new
    post "/orgs", OrgController, :create
    get "/orgs/:id/edit", OrgController, :edit
    put "/orgs/:id", OrgController, :update
    delete "/orgs/:id", OrgController, :delete
    put "/orgs/:id/restore", OrgController, :restore

    get "/contacts", ContactController, :index
    get "/contacts/new", ContactController, :new
    post "/contacts", ContactController, :create
    get "/contacts/:id/edit", ContactController, :edit
    put "/contacts/:id", ContactController, :update
    delete "/contacts/:id", ContactController, :delete
    put "/contacts/:id/restore", ContactController, :restore

    get "/reports", ReportController, :index
  end

  scope "/", PingCRM.Web do
    pipe_through [:browser]

    delete "/logout", UserSessionController, :delete
  end

  scope "/", PingCRM.Web do
    pipe_through [:browser]

    get "/*path", ErrorController, :not_found
  end

  if PingCRM.Env.dev?() do
    scope "/dev" do
      pipe_through :browser
    end
  end
end
