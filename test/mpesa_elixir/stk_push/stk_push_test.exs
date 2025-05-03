defmodule MpesaElixir.StkPush.StkPushTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import Mox

  alias MpesaElixir.StkPush
  alias MpesaElixir.StkPush.QueryRequest
  alias MpesaElixir.StkPush.Request

  setup :verify_on_exit!

  setup do
    stub_with(MpesaElixir.APIMock, MpesaElixir.API)
    :ok
  end

  describe "request" do
    @valid_request %Request{
      business_short_code: "174379",
      password:
        "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
      timestamp: "20160216165627",
      transaction_type: "CustomerPayBillOnline",
      amount: "1",
      party_a: "254708374149",
      party_b: "174379",
      phone_number: "254708374149",
      call_back_url: "https://example.com/callback",
      account_reference: "1234567890",
      transaction_desc: "Payment for goods"
    }

    @success_response %{
      "MerchantRequestID" => "29115-34620561-1",
      "CheckoutRequestID" => "ws_CO_191220191020363925",
      "ResponseCode" => "0",
      "ResponseDescription" => "Success. Request accepted for processing",
      "CustomerMessage" => "Success. Request accepted for processing"
    }

    @error_response %{
      "ResponseCode" => "400.002.05",
      "ResponseDescription" => "Invalid Request Payload"
    }

    test "successfully initiates STK Push request" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:ok, %Req.Response{status: 200, body: @success_response}}
      end)

      assert {:ok, @success_response} == StkPush.request(@valid_request)
    end

    test "handles missing password and timestamp" do
      request =
        @valid_request
        |> Map.put(:password, nil)
        |> Map.put(:timestamp, nil)

      expect(MpesaElixir.APIMock, :request, fn _url, opts ->
        refute is_nil(opts[:body]["Timestamp"])
        refute is_nil(opts[:body]["Password"])
        {:ok, %Req.Response{status: 200, body: @success_response}}
      end)

      assert {:ok, @success_response} == StkPush.request(request)
    end

    test "handles error response" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:ok, %Req.Response{status: 400, body: @error_response}}
      end)

      assert {:error, @error_response} == StkPush.request(@valid_request)
    end

    test "handles network error" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:error, %Req.TransportError{reason: :timeout}}
      end)

      assert {:error, :timeout} == StkPush.request(@valid_request)
    end
  end

  describe "query_stk_push_status" do
    @success_response %{
      "ResponseCode" => "0",
      "ResponseDescription" => "The service request has been accepted successfully",
      "MerchantRequestID" => "22205-34066-1",
      "CheckoutRequestID" => "ws_CO_13012021093521236557",
      "ResultCode" => "0",
      "ResultDesc" => "The service request is processed successfully."
    }

    @error_response %{
      "ResponseCode" => "400.002.05",
      "ResponseDescription" => "Invalid Request Payload"
    }

    @valid_request %QueryRequest{
      business_short_code: "174379",
      password:
        "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
      timestamp: "20160216165627",
      checkout_request_id: "ws_CO_191220191020363925"
    }

    @invalid_request %QueryRequest{
      business_short_code: "33333",
      password: nil,
      timestamp: nil,
      checkout_request_id: "ws_CO_191220191020363925"
    }

    test "successfully queries STK Push status" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:ok, %Req.Response{status: 200, body: @success_response}}
      end)

      assert {:ok, @success_response} == StkPush.query_stk_push_status(@valid_request)
    end

    test "handles missing password and timestamp" do
      request =
        %QueryRequest{
          business_short_code: "174379",
          password: nil,
          timestamp: nil,
          checkout_request_id: "ws_CO_191220191020363925"
        }

      expect(MpesaElixir.APIMock, :request, fn _url, opts ->
        refute is_nil(opts[:body]["Timestamp"])
        refute is_nil(opts[:body]["Password"])
        {:ok, %Req.Response{status: 200, body: @success_response}}
      end)

      assert {:ok, @success_response} == StkPush.query_stk_push_status(request)
    end

    test "handles error response" do
      expect(MpesaElixir.APIMock, :request, fn _url, _opts ->
        {:ok, %Req.Response{status: 400, body: @error_response}}
      end)

      assert {:error, @error_response} == StkPush.query_stk_push_status(@invalid_request)
    end

  end
end
