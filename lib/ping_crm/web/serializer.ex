defmodule PingCRM.Web.Serializer do
  @moduledoc """

  ## Usage

  Support that we have an Ecto schema:

      defmodule MyApp.Core.Post do
        use Ecto.Schema

        schema "posts" do
          field :title, :string
          field :body, :string
          timestamps()
        end
      end

  Before serializing it, let's define a serializer module first:

      defmodule MyApp.Web.PostJSON do
        use MyApp.Web.Serializer
        alias MyApp.Core.Post

        @impl true
        def serialize(%Post{} = post) do
          %{
            id: post.id,
            title: post.title,
            body: post.body
          }
        end

        @impl true
        def serialize(%Post{} = post, :compact) do
          %{
            id: post.id,
            title: post.title
          }
        end
      end

  To serialize a post:

      alias MyApp.Web.Serializer
      alias MyApp.Web.PostJSON

      Serializer.serialize(post, PostJSON)
      Serializer.serialize(post, {PostJSON, :compact})

  """

  @type format :: atom()
  @type serializer :: module() | {module(), format()}
  @type serializable :: any()
  @type serialized :: any()

  @callback serialize(serializable()) :: serialized()
  @callback serialize(serializable(), format()) :: serialized()
  @optional_callbacks [serialize: 1, serialize: 2]

  defmacro __using__(_) do
    quote do
      @behaviour PingCRM.Web.Serializer
      import PingCRM.Web.Serializer, only: [wrap_assoc: 2]
    end
  end

  @doc """
  Serializes data with given serializer and format.

  ## Examples

     iex> alias PingCRM.Web.Serializer
     iex> Serializer.serialize(post, {PostJSON})
     iex> Serializer.serialize(post, {PostJSON, :compact})

  """
  @spec serialize([serializable()], serializer()) :: [serialized()]
  def serialize(list, mod) when is_list(list) and is_atom(mod) do
    for data <- list, do: mod.serialize(data)
  end

  def serialize(list, {mod, format}) when is_list(list) and is_atom(mod) and is_atom(format) do
    for data <- list, do: mod.serialize(data, format)
  end

  @spec serialize(serializable(), serializer()) :: serialized()
  def serialize(data, mod) when is_atom(mod) do
    mod.serialize(data)
  end

  def serialize(data, {mod, format}) when is_atom(mod) and is_atom(format) do
    mod.serialize(data, format)
  end

  def wrap_assoc(%Ecto.Association.NotLoaded{}, _serializer) do
    %{loaded: false, data: nil}
  end

  def wrap_assoc(nil, _serializer) do
    %{loaded: true, data: nil}
  end

  def wrap_assoc(data, serializer) do
    %{loaded: true, data: serialize(data, serializer)}
  end
end
