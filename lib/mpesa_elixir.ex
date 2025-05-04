defmodule MpesaElixir do
  @moduledoc false

  alias MpesaElixir.API

  @doc """
    Makes a universal HTTP request to the M-Pesa API endpoint.

    This function serves as a generic request handler for all M-Pesa API calls.
    It accepts a URL endpoint and parameters map, encodes the parameters as JSON,
    and processes the response.

    ## Parameters

      * `url` - String representing the API endpoint URL
      * `params` - Map containing the request parameters to be JSON-encoded

    ## Returns

      * `{:ok, map()}` - On successful request with the response data
      * `{:error, String.t()}` - On request failure with an error message

    ## Examples

        iex> MpesaElixir.request("/mpesa/stkpush/v1/processrequest", %{
          "Amount" => 1,
          "PhoneNumber" => "254712345678",
          # other parameters...
        })
        {:ok, %{"ResponseCode" => "0", "ResponseDescription" => "Success"}}
  """
  @spec request(String.t(), map()) :: {:ok, map()} | {:error, String.t()}
  def request(url, params) when is_map(params) do
    url
    |> API.request(body: Jason.encode!(params))
    |> API.handle_response()
  end
end
