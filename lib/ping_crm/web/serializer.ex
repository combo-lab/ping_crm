defmodule PingCRM.Web.Serializer do
  @moduledoc """
  Provides a behaviour for serializing data into maps or lists, with support
  for variants and association handling.

  ## Usage

  Support that we have an Ecto schema:

      defmodule PingCRM.Core.Post do
        use Ecto.Schema

        schema "posts" do
          field :title, :string
          field :body, :string
          timestamps()
        end
      end

  Before serializing it, let's define a serializer module first:

      defmodule PingCRM.Web.PostJSON do
        use PingCRM.Web.Serializer
        alias PingCRM.Core.Post

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

      alias PingCRM.Web.Serializer
      alias PingCRM.Web.PostJSON

      Serializer.serialize(post, PostJSON)
      Serializer.serialize(post, {PostJSON, :compact})

  """

  @type variant :: atom()
  @type serializer :: module() | {module(), variant()}
  @type serializable :: any()
  @type serialized :: any()

  @callback serialize(serializable()) :: serialized()
  @callback serialize(serializable(), variant()) :: serialized()
  @optional_callbacks [serialize: 1, serialize: 2]

  defmacro __using__(_) do
    quote do
      @behaviour PingCRM.Web.Serializer
      import PingCRM.Web.Serializer, only: [wrap_assoc: 2]
    end
  end

  @doc """
  Serializes data with given serializer and variant.

  ## Examples

     iex> alias PingCRM.Web.Serializer
     iex> Serializer.serialize(post, PostJSON)
     iex> Serializer.serialize(post, {PostJSON, :compact})

  """
  @spec serialize([serializable()], serializer()) :: [serialized()]
  def serialize(list, mod) when is_list(list) and is_atom(mod) do
    for data <- list, do: mod.serialize(data)
  end

  def serialize(list, {mod, variant}) when is_list(list) and is_atom(mod) and is_atom(variant) do
    for data <- list, do: mod.serialize(data, variant)
  end

  @spec serialize(serializable(), serializer()) :: serialized()
  def serialize(data, mod) when is_atom(mod) do
    mod.serialize(data)
  end

  def serialize(data, {mod, variant}) when is_atom(mod) and is_atom(variant) do
    mod.serialize(data, variant)
  end

  @doc """
  Wraps an Ecto association into `%{loaded: boolean(), data: serialized() | nil}`
  format.

  It helps distinguish between three states:

    * not loaded
    * loaded but empty
    * loaded with data

  """
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
