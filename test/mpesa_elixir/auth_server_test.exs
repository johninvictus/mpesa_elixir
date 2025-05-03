defmodule MpesaElixir.AuthServerTest do
  @moduledoc false
  use ExUnit.Case, async: false

  # alias MpesaElixir.AuthServer

  import ExUnit.CaptureLog
  import Req.Test

  setup :set_req_test_from_context
  setup :verify_on_exit!

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

    Req.Test.stub(MpesaElixir.API, fn conn ->
      Req.Test.json(conn, %{
        "access_token" => test_token,
        "expires_in" => test_expires
      })
    end)

    {:ok, pid} = MpesaElixir.AuthServer.start_link([])
    :timer.sleep(100)

    assert MpesaElixir.AuthServer.get_token() == test_token
    GenServer.stop(pid)
  end

  test "token refresh after expiration" do
    # First request returns a token that expires in 200 seconds
    Req.Test.stub(MpesaElixir.API, fn conn ->
      conn
      |> Req.Test.json(%{
        "access_token" => "initial_token_#{Enum.random(1..1000)}",
        "expires_in" => "1"
      })
    end)

    {:ok, pid} = MpesaElixir.AuthServer.start_link([])
    :timer.sleep(100)

    token = MpesaElixir.AuthServer.get_token()

    refute token == ""
    # Wait for refresh (200-100 seconds)
    :timer.sleep(150)

    # Check if token was refreshed
    refute MpesaElixir.AuthServer.get_token() == token

    # Clean up
    Process.exit(pid, :normal)
  end

  test "server handles error response" do
    Req.Test.stub(MpesaElixir.API, fn conn ->
      Req.Test.transport_error(conn, :timeout)
    end)

    log =
      capture_log(fn ->
        {:ok, _pid} = MpesaElixir.AuthServer.start_link([])
        :timer.sleep(100)

        assert MpesaElixir.AuthServer.get_token() == ""
      end)

    assert log =~ "timeout"
  end

  test "invalid grant type passed" do
    # Capture logs to verify error is properly logged
    log =
      capture_log(fn ->
        Req.Test.stub(MpesaElixir.API, fn conn ->
          conn
          |> Plug.Conn.put_status(400)
          |> Req.Test.json(%{
            "requestId" => "923a-43bc-a9d4-f88008a5da063818897",
            "errorCode" => "400.008.02",
            "errorMessage" => "Invalid grant type passed"
          })
        end)

        # Start the server and capture the exit reason
        Process.flag(:trap_exit, true)
        {:ok, pid} = MpesaElixir.AuthServer.start_link([])

        # Give the GenServer time to process the continue callback and terminate
        :timer.sleep(100)

        # Verify the process has terminated with the expected reason
        assert Process.alive?(pid) == false
      end)

    # Verify error was logged
    assert log =~ "Error fetching token"
    assert log =~ "Invalid grant type passed"
  end
end
