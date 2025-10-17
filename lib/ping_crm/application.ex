defmodule PingCRM.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    if stacktrace_depth = Application.get_env(:ping_crm, :stacktrace_depth, nil) do
      :erlang.system_flag(:backtrace_depth, stacktrace_depth)
    end

    children = [
      PingCRM.PubSub,
      PingCRM.Core.Supervisor,
      PingCRM.Web.Supervisor
    ]

    opts = [strategy: :one_for_one, name: PingCRM.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
