defmodule PingCRM.Web.ErrorController do
  use PingCRM.Web, :controller

  def not_found(conn, _params) do
    status = 404

    conn
    |> put_status(status)
    |> inertia_render("Error", %{status: status})
  end
end
