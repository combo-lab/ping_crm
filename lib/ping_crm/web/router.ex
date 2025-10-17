defmodule PingCRM.Web.Router do
  use PingCRM.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_layout, html: {PingCRM.Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Combo.Vite.Plug
    plug Combo.Inertia.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PingCRM.Web do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", PingCRM.Web do
    pipe_through :api
  end

  if PingCRM.Env.dev?() do
    scope "/dev" do
      pipe_through :browser
    end
  end
end
