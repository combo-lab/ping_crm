defmodule PingCRM.Core.EasyToken do
  @moduledoc """
  Generates, hashes, verifies token in one place.

  Currently, it supports following formats of tokens:

    * `:binary`

  """

  @hash_algorithm :sha256

  @type format :: {:binary, keyword()}
  @type token :: String.t()
  @type token_hash :: binary()

  @doc """
  Generates a token with a given format.

  It returns a 2-element tuple:

    * the first element is the token.
    * the second element is the hashed token.

  ## Examples

      iex> generate({:binary, size: 32})
      {"BrZOU2e-ysMA9vs2v4juaBUlm05jAwPZfSGPbjiuRA8", <<177, 240, ...>>}

  """
  @spec generate(format()) :: {token(), token_hash()}
  def generate({:binary, opts}) do
    rand_size = Keyword.get(opts, :size, 32)

    token_bytes = :crypto.strong_rand_bytes(rand_size)
    token = Base.url_encode64(token_bytes, padding: false)
    token_hash = :crypto.hash(@hash_algorithm, token_bytes)

    {token, token_hash}
  end

  @doc """
  Hashes a token without verifying it.
  """
  @spec hash(format(), token()) :: {:ok, token_hash()} | :error
  def hash({:binary, _opts}, token) do
    case Base.url_decode64(token, padding: false) do
      {:ok, token_bytes} ->
        token_hash = :crypto.hash(@hash_algorithm, token_bytes)
        {:ok, token_hash}

      _ ->
        :error
    end
  end

  @doc """
  Hashes and verifies a token.
  """
  @spec verify(format(), token(), token_hash()) :: :ok | :error
  def verify({type, _opts} = format, token, token_hash) when type in [:binary, :digit] do
    with {:ok, current_token_hash} <- hash(format, token) do
      if current_token_hash == token_hash, do: :ok, else: :error
    end
  end
end
