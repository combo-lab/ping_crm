defmodule PingCRM.Web.AccountJSON do
  use PingCRM.Web, :serializer

  alias PingCRM.Core.Accounts.Account

  def serialize(%Account{} = account) do
    %{
      id: account.id,
      name: account.name
    }
  end
end
