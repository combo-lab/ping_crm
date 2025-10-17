defmodule PingCRM.Web.Supervisor do
  use Supervisor

  @spec start_link(term()) :: Supervisor.on_start()
  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl Supervisor
  def init(_arg) do
    children =
      Enum.concat(
        inertia_children(),
        [
          PingCRM.Web.Endpoint
        ]
      )

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp inertia_children do
    config = Application.get_env(:ping_crm, PingCRM.Web.Endpoint)
    ssr? = get_in(config, [:inertia, :ssr])

    if ssr? do
      path = Path.join([Application.app_dir(:ping_crm), "priv/ssr"])
      [{Combo.Inertia.SSR, path: path}]
    else
      []
    end
  end
end
