defmodule MpesaElixir.C2bTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import Mox

  alias MpesaElixir.C2b
  alias MpesaElixir.C2b.RegisterRequest

  setup :verify_on_exit!

  setup do
    stub_with(MpesaElixir.APIMock, MpesaElixir.API)
    :ok
  end

  describe "register_urls/1" do
    @valid_request %RegisterRequest{
      short_code: "600000",
      response_type: "Completed",
      confirmation_url: "https://example.com/mpesa/confirmation",
      validation_url: "https://example.com/mpesa/validation"
    }

    @success_response %{
      "ConversationID" => "AG_20230815_1234567890abcdef",
      "OriginatorCoversationID" => "12345-67890-1",
      "ResponseDescription" => "Success"
    }

    @error_response %{
      "ResponseCode" => "400.002.05",
      "ResponseDescription" => "Invalid Request Payload"
    }

    test "successfully registers URLs" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:ok, %Req.Response{status: 200, body: @success_response}}
      end)

      assert {:ok, @success_response} == C2b.register_urls(@valid_request)
    end

    test "handles error response" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:ok, %Req.Response{status: 400, body: @error_response}}
      end)

      assert {:error, @error_response} == C2b.register_urls(@valid_request)
    end

    test "handles network error" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:error, %Req.TransportError{reason: :timeout}}
      end)

      assert {:error, :timeout} == C2b.register_urls(@valid_request)
    end
  end
end
