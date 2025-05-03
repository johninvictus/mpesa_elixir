defmodule MpesaElixir.StkPush do
  @moduledoc """
  Provides functionality for initiating M-Pesa STK Push requests.

  The STK Push (also known as Lipa na M-PESA online or Network Initiated push)
  allows merchants to initiate C2B (Customer to Business) payments by sending
  a payment prompt to a customer's M-PESA registered phone number.

  This module handles the creation and submission of STK Push requests to the
  M-Pesa API, managing authentication details and proper formatting of the request.

  ## How it works

  1. The merchant captures necessary parameters and sends an API request
  2. M-Pesa validates the request and sends an acknowledgment
  3. An STK Push prompt is sent to the customer's phone
  4. Customer confirms by entering their M-PESA PIN
  5. M-Pesa processes the transaction (validating PIN, debiting customer, crediting merchant)
  6. Results are sent back via the specified callback URL
  7. Customer receives an SMS confirmation

  ## Example

      alias MpesaElixir.StkPush
      alias MpesaElixir.StkPush.Request

      request = Request.new(%{
        business_short_code: "174379",
        transaction_type: "CustomerPayBillOnline",
        amount: "100",
        party_a: "254712345678",
        party_b: "174379",
        phone_number: "254712345678",
        call_back_url: "https://mydomain.com/callback",
        account_reference: "Payment for order #1234",
        transaction_desc: "Order payment"
      })

      case StkPush.request(request) do
        {:ok, response} ->
          # Handle successful request submission
          # The response contains MerchantRequestID and CheckoutRequestID
          # Final transaction results will be sent to the callback URL
        {:error, reason} ->
          # Handle error
      end
  """

  alias MpesaElixir.API
  alias MpesaElixir.StkPush.Request

  @doc """
  Initiates an STK Push request to the M-Pesa API.

  This function takes a `Request` struct, automatically generates the password
  and timestamp if they are not provided, and sends the request to the M-Pesa API.

  The password is generated using the formula: Base64(BusinessShortCode + PassKey + Timestamp)
  where PassKey is configured in the application environment.

  ## Parameters

    * `request` - A `MpesaElixir.StkPush.Request` struct containing all required parameters

  ## Returns

    * `{:ok, response}` - On successful submission, returns the API response containing
      MerchantRequestID and CheckoutRequestID
    * `{:error, reason}` - If the request fails

  ## Example

      request = MpesaElixir.StkPush.Request.new(%{
        business_short_code: "174379",
        transaction_type: "CustomerPayBillOnline",
        amount: "100",
        party_a: "254712345678",
        party_b: "174379",
        phone_number: "254712345678",
        call_back_url: "https://mydomain.com/callback",
        account_reference: "Order #1234",
        transaction_desc: "Order payment"
      })

      MpesaElixir.StkPush.request(request)
  """
  @spec request(Request.t()) :: {:ok, map()} | {:error, any()}
  def request(%Request{} = request) do
    api_module = Application.get_env(:mpesa_elixir, :api_module, MpesaElixir.API)

    "/mpesa/stkpush/v1/processrequest"
    |> api_module.request(body: Request.to_api_map(request))
    |> API.handle_response()
  end

  @spec request(Request.t()) :: {:ok, map()} | {:error, any()}
  def query_stk_push_status(request) do
    api_module = Application.get_env(:mpesa_elixir, :api_module, MpesaElixir.API)

    "/mpesa/stkpushquery/v1/query"
    |> api_module.request(body: Request.to_api_map(request))
    |> API.handle_response()
  end
end
