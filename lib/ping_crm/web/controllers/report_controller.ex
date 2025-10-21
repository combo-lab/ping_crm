defmodule PingCRM.Web.ReportController do
  use PingCRM.Web, :controller

  def index(conn, _params) do
    inertia_render(conn, "Reports/Index")
  end
end
