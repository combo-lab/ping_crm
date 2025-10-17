defmodule PingCRM.Web.PageController do
  use PingCRM.Web, :controller

  def home(conn, _params) do
    conn
    |> inertia_render("Home")
  end
end
