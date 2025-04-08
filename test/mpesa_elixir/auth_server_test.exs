defmodule MpesaElixir.AuthServerTest do
  @moduledoc false
  use ExUnit.Case, async: false

  import Mock
  alias MpesaElixir.AuthServer

  setup do
    Application.put_env(:mpesa_elixir, :consumer_key, "test_key")
    Application.put_env(:mpesa_elixir, :consumer_secret, "test_secret")

    on_exit(fn ->
      Application.delete_env(:mpesa_elixir, :consumer_key)
      Application.delete_env(:mpesa_elixir, :consumer_secret)
    end)
  end

  test "server initializes and fetches token" do
    test_token = "test_access_token"
    test_expires = "3600"
  end
end
