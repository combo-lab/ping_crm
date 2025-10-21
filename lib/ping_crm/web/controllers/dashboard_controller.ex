defmodule PingCRM.Web.DashboardController do
  use PingCRM.Web, :controller

  def index(conn, _params) do
    conn
    |> inertia_render("Dashboard/Index")
  end
end
