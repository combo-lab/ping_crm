defmodule PingCRM.Core.SoftDeletion do
  import Ecto.Query

  @spec change_to_active(Ecto.Schema.t()) :: Ecto.Changeset.t()
  def change_to_active(data) do
    Ecto.Changeset.change(data, %{deleted_at: nil})
  end

  @spec change_to_deleted(Ecto.Schema.t()) :: Ecto.Changeset.t()
  def change_to_deleted(data) do
    Ecto.Changeset.change(data, %{deleted_at: DateTime.utc_now()})
  end

  @spec filter_by_active(Ecto.Queryable.t()) :: Ecto.Query.t()
  def filter_by_active(queryable) do
    where(queryable, [q], is_nil(q.deleted_at))
  end

  @spec filter_by_deleted(Ecto.Queryable.t()) :: Ecto.Query.t()
  def filter_by_deleted(queryable) do
    where(queryable, [q], not is_nil(q.deleted_at))
  end
end
