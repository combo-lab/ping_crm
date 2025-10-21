defmodule PingCRM.Web.ErrorController do
  use PingCRM.Web, :controller

  def not_found(conn, _params) do
    conn
    |> inertia_render("Error", %{status: 404})
  end
end
