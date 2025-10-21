defmodule PingCRM.Web.Inertia do
  import Combo.Inertia.Conn
  alias PingCRM.Web.Serializer
  alias PingCRM.Web.UserJSON

  def put_inertia_share(conn, _opts) do
    conn
    |> put_auth()
  end

  defp put_auth(conn) do
    user =
      if current_user = conn.assigns.current_user do
        Serializer.serialize(current_user, {UserJSON, :auth})
      end

    inertia_put_prop(conn, :auth, %{
      user: user
    })
  end
end
