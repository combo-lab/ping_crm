defmodule PingCRM.Web.UserSessionController do
  use PingCRM.Web, :controller

  alias PingCRM.Core.Accounts
  alias PingCRM.Web.UserAuth

  def show(conn, _params) do
    conn
    |> inertia_render("UserSession/Login")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user)
    else
      conn
      |> inertia_put_errors(%{
        credentials: "Incorrect email or password."
      })
      |> redirect(to: ~p"/login")
    end
  end

  def delete(conn, _params) do
    UserAuth.log_out_user(conn)
  end
end
