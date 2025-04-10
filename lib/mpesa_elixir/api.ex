defmodule MpesaElixir.API do
  @moduledoc """
  HTTP client for interacting with the M-Pesa API.

  This module provides a lightweight wrapper around the Req HTTP client,
  specifically configured for making requests to the Safaricom M-Pesa API.
  It handles authentication, request formatting, and environment-specific
  base URLs.

  ## Features

  - Automatic bearer token authentication
  - JSON request body encoding
  - Content-type header management
  - Environment-aware base URL selection (sandbox vs production)
  - Simplified request interface

  ## Examples

  ```elixir
  # Simple request to an M-Pesa endpoint
  MpesaElixir.API.request("/mpesa/stkpush/v1/processrequest",
    body: %{
      BusinessShortCode: "174379",
      Password: "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMjAwMjE2MTY1NjI4",
      Timestamp: "20200216165628",
      TransactionType: "CustomerPayBillOnline",
      Amount: 1,
      PartyA: "254712345678",
      PartyB: "174379",
      PhoneNumber: "254712345678",
      CallBackURL: "https://example.com/callback",
      AccountReference: "Test",
      TransactionDesc: "Test"
    }
  )

  # Creating a customized client for multiple requests
  client = MpesaElixir.API.new(
    base_url: "https://custom-mpesa-proxy.example.com",
    retry: [max_attempts: 3]
  )

  Req.post(client, url: "/some/endpoint", body: %{key: "value"})
  ```

  ## Configuration

  Configure the environment in your application config:

  ```elixir
  # For sandbox environment
  config :mpesa_elixir, sandbox: true

  # For production environment
  config :mpesa_elixir, sandbox: false
  ```
  """
  alias MpesaElixir.AuthServer

  def new(opts \\ []) do
    [
      base_url: base_url(),
      auth: {:bearer, AuthServer.get_token()}
    ]
    |> Req.new()
    |> Req.Request.put_header("content-type", "application/json")
    |> Req.Request.append_request_steps(
      encode: fn req ->
        with %{body: %{} = body} <- req do
          %{req | body: Jason.encode!(body)}
        end
      end
    )
    |> Req.Request.append_request_steps(
      post: fn req ->
        with %{method: :get, body: <<_::binary>>} <- req do
          %{req | method: :post}
        end
      end
    )
    |> Req.merge(opts)
  end

  def request(url, opts \\ []) do
    [url: url]
    |> new()
    |> Req.request(opts)
  end

  def handle_response({:ok, %Req.Response{status: 200, body: body}}) do
    {:ok, body}
  end

  def handle_response({:ok, %Req.Response{status: _status, body: body}}) do
    {:error, body}
  end

  def handle_response({:error, %Req.TransportError{reason: reason}}) do
    {:error, reason}
  end

  defp base_url do
    if Application.get_env(:mpesa_elixir, :sandbox, false) do
      "https://sandbox.safaricom.co.ke"
    else
      "https://api.safaricom.co.ke"
    end
  end
end
