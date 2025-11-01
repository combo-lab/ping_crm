defmodule PingCRM.Core.EasyTokenTest do
  use ExUnit.Case, async: true

  alias PingCRM.Core.EasyToken

  describe "generate/1, hash/2 and verify/3" do
    test "for :binary format" do
      format = {:binary, size: 64}

      assert {token, token_hash} = EasyToken.generate(format)
      assert {:ok, ^token_hash} = EasyToken.hash(format, token)
      assert :ok = EasyToken.verify(format, token, token_hash)
      assert :error = EasyToken.verify(format, "bad", token_hash)
    end
  end
end
