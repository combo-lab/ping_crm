defmodule PingCRM.Web.Endpoint do
  use Combo.Endpoint, otp_app: :ping_crm

  plug Plug.Static,
    at: "/",
    from: {:ping_crm, "priv/static"},
    only: PingCRM.Web.static_paths(),
    raise_on_missing_only: PingCRM.Env.dev?()

  if live_reloading? do
    socket "/combo/live_reloader/socket", Combo.LiveReloader.Socket
    plug Combo.LiveReloader
  end

  if code_reloading? do
    plug Combo.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:combo, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Combo.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_ping_crm_web_session",
    signing_salt: "602B4oR0",
    same_site: "Lax"

  plug PingCRM.Web.Router
end
