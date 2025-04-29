defmodule MpesaElixir.C2b do
  @moduledoc """
  Provides functionality for integrating with Safaricom's M-PESA Customer to Business (C2B) API.
  This module enables businesses to receive payments from customers directly to their M-PESA accounts
  through register_urls functionality that configures callback URLs for payment notifications.

  C2B allows businesses to register validation and confirmation URLs that receive real-time
  notification of payments made to their paybill or till numbers, enabling automated payment
  processing and reconciliation.
  """
  use TypedStruct

  alias __MODULE__.RegisterRequest
  alias MpesaElixir.API

  typedstruct module: RegisterRequest do
    field(:short_code, String.t())
    field(:response_type, String.t())
    field(:confirmation_url, String.t())
    field(:validation_url, String.t())
  end

  @doc """
  Register URL API works hand in hand with Customer to Business (C2B) APIs and allows receiving payment notifications
  to your paybill. This API enables you to register the callback URLs via which you shall receive notifications for
  payments to your pay bill/till number.
  """
  @spec register_urls(RegisterRequest.t()) :: {:ok, map()} | {:error, String.t()}
  def register_urls(%RegisterRequest{} = request) do
    payload = %{
      "ShortCode" => request.short_code,
      "ResponseType" => request.response_type,
      "ConfirmationURL" => request.confirmation_url,
      "ValidationURL" => request.validation_url
    }

    "/mpesa/c2b/v1/registerurl"
    |> API.request(body: payload)
    |> API.handle_response()
  end
end
