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
    field(:short_code, integer())
    field(:response_type, String.t())
    field(:confirmation_url, String.t())
    field(:validation_url, String.t())
  end

  @doc """
  Registers callback URLs for M-PESA C2B payment notifications.

  This function configures the validation and confirmation URLs that will receive real-time
  notifications when customers make payments to your paybill or till number. These URLs must be
  publicly accessible HTTPS endpoints that can receive and process the payment data.

  ## Parameters

  * `request` - A `RegisterRequest` struct containing:
    * `short_code` - Your M-PESA till or paybill number
    * `response_type` - The type of response expected:
      * `"Completed"` - Payments are automatically completed after confirmation
      * `"Cancelled"` - Payments may be validated before completion
    * `confirmation_url` - The HTTPS URL that receives payment confirmation data
    * `validation_url` - The HTTPS URL that receives payment validation requests

  ## Response

  Returns `{:ok, response}` on success where `response` is a map containing:
  * `"ConversationID"` - A unique identifier for the API request
  * `"OriginatorCoversationID"` - A unique identifier for the transaction
  * `"ResponseDescription"` - A description of the operation result

  Returns `{:error, reason}` on failure.

  ## Examples

      iex> request = %MpesaElixir.C2b.RegisterRequest{
      ...>   short_code: "600000",
      ...>   response_type: "Completed",
      ...>   confirmation_url: "https://example.com/mpesa/confirmation",
      ...>   validation_url: "https://example.com/mpesa/validation"
      ...> }
      iex> MpesaElixir.C2b.register_urls(request)
      {:ok, %{
        "ConversationID" => "AG_20230815_1234567890abcdef",
        "OriginatorCoversationID" => "12345-67890-1",
        "ResponseDescription" => "Success. Request accepted for processing"
      }}

  ## Notes

  * Both URLs must be secure (HTTPS) and publicly accessible
  * The validation URL receives requests before payment completion and can accept/reject them
  * The confirmation URL receives notification after a successful payment
  * Response type "Completed" is recommended for most use cases to simplify the payment flow
  * If your URLs change, you need to re-register them using this API
  * The endpoints will receive JSON payloads with transaction details
  """
  @spec register_urls(RegisterRequest.t()) :: {:ok, map()} | {:error, String.t()}
  def register_urls(%RegisterRequest{} = request) do
    # Get the API module to use (real or mock)
    api_module = Application.get_env(:mpesa_elixir, :api_module, MpesaElixir.API)

    payload = %{
      "ShortCode" => request.short_code,
      "ResponseType" => request.response_type,
      "ConfirmationURL" => request.confirmation_url,
      "ValidationURL" => request.validation_url
    }

    "/mpesa/c2b/v1/registerurl"
    |> api_module.request(body: payload)
    |> API.handle_response()
  end
end
