defmodule MpesaElixir.QrCodeTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import Mox

  setup :verify_on_exit!

  # Let's add some test data
  @valid_request %MpesaElixir.QrCode.Request{
    merchant_name: "TEST SUPERMARKET",
    ref_no: "Invoice Test",
    amount: 1,
    trx_code: "BG",
    cpi: "373132",
    size: "300"
  }

  @success_response %{
    "ResponseCode" => "AG_20191219_000043fdf61864fe9ff5",
    "RequestID" => "16738-27456357-1",
    "ResponseDescription" => "QR Code Successfully Generated.",
    "QRCode" =>
      "iVBORw0KGgoAAAANSUhEUgAAASwAAAEsCAIAAAD2HxkiAAAHtElEQVR42u3d23rqIBAGUN//pbNv91c1cpwMsP7L1lg"
  }

  @error_response %{
    "ResponseCode" => "400.002.05",
    "ResponseDescription" => "Invalid Request Payload"
  }

  describe "generate/1" do
    test "successfully generates QR code" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:ok, %Req.Response{status: 200, body: @success_response}}
      end)

      assert {:ok, @success_response} == MpesaElixir.QrCode.generate(@valid_request)
    end

    test "handles error response" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:ok, %Req.Response{status: 400, body: @error_response}}
      end)

      assert {:error, @error_response} == MpesaElixir.QrCode.generate(@valid_request)
    end

    test "handles network error" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:error, %Req.TransportError{reason: :timeout}}
      end)

      assert {:error, :timeout} == MpesaElixir.QrCode.generate(@valid_request)
    end
  end
end
