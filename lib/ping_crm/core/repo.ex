defmodule PingCRM.Core.Repo do
  use Ecto.Repo,
    otp_app: :ping_crm,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [offset: 2, limit: 2]

  @doc """
  Runs the given function inside a transaction.

  This function is a wrapper around `Repo.transact/2`, with the following
  differences.

  * It accepts only a lambda of arity 0 or 1:
    * If the lambda returns `:ok` or `{:ok, result}`, the transaction is
      committed.
    * If the lambda returns `:error` or `{:error, reason}`, the transaction is
      rolled back.
    * If the lambda returns any other kind of result, an exception is raised,
      and the transaction is rolled back.
  * It doesn't work with `Ecto.Multi`
  * It accepts the same options as `Repo.transact/2`.
  * The result of `transact/2` is the value returned by the lambda.

  ## Examples

      Repo.tx(fn ->
        with {:ok, post} <- store_post_record(post, title, body),
             :ok <- create_notifications(post),
             do: {:ok, post}
      end)

  ## Notes

  This code is originally written by
  [Saša Jurić](https://github.com/sasa1977/mix_phx_alt/blob/d33a67fd6b2fa0ace5b6206487e774ef7a22ce5a/lib/core/repo.ex#L6).

  """
  @spec tx((-> result) | (module() -> result), Keyword.t()) :: result
        when result: :ok | {:ok, any()} | :error | {:error, any()}
  def tx(fun, opts \\ []) do
    fun_wrapper = fn repo ->
      fun_result =
        case Function.info(fun, :arity) do
          {:arity, 0} -> fun.()
          {:arity, 1} -> fun.(repo)
        end

      case fun_result do
        :ok ->
          {:ok, {__MODULE__, :tx}}

        :error ->
          {:error, {__MODULE__, :tx}}

        {:ok, result} ->
          {:ok, result}

        {:error, reason} ->
          {:error, reason}

        other ->
          raise ArgumentError, """
          expected to return :ok, :error, {:ok, _} or {:error, _}, got: #{inspect(other)}\
          """
      end
    end

    case transact(fun_wrapper, opts) do
      {outcome, {__MODULE__, :tx}} when outcome in [:ok, :error] -> outcome
      other -> other
    end
  end

  @type paginate_opt :: {:page, pos_integer()} | {:page_size, pos_integer()}
  @type paginate_opts :: [paginate_opt()]
  @type pagination_meta :: %{
          page: pos_integer(),
          page_size: pos_integer(),
          total_count: non_neg_integer(),
          total_pages: non_neg_integer(),
          has_prev_page: boolean(),
          has_next_page: boolean()
        }

  @spec paginate(Ecto.Queryable.t(), paginate_opts()) :: {list(), pagination_meta()}
  def paginate(queryable, opts) do
    page = Keyword.get(opts, :page) || 1
    page_size = Keyword.get(opts, :page_size) || 10

    repo = __MODULE__
    pagination_query = build_pagination_query(queryable, page, page_size)

    total_count = repo.aggregate(queryable, :count)
    total_pages = ceil(total_count / page_size)

    has_prev_page = page > 1
    has_next_page = page < total_pages

    paginated_data = repo.all(pagination_query)

    pagination_meta = %{
      page: page,
      page_size: page_size,
      total_count: total_count,
      total_pages: total_pages,
      has_prev_page: has_prev_page,
      has_next_page: has_next_page
    }

    {paginated_data, pagination_meta}
  end

  defp build_pagination_query(queryable, page, page_size)
       when is_integer(page) and page > 0 and (is_integer(page_size) and page_size > 0) do
    offset = (page - 1) * page_size
    limit = page_size

    queryable
    |> offset(^offset)
    |> limit(^limit)
  end
end
