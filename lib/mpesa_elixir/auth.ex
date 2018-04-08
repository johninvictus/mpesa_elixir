defmodule MpesaElixir.Auth do
  alias MpesaElixir.Auth
  alias MpesaElixir.PublicKey

  use HTTPotion.Base

  @moduledoc """
  This module will be used to generate a token to use everytime making an API call to mpesa servers
  """

  @type response ::
          {:ok, %Auth{}, HTTPotion.Response.t()}
          | {:error, HTTPotion.ErrorResponse.t()}
          | {:local_error, String.t()}

  defstruct access_token: nil, expires_in: nil

  @doc """
  get customer key from config file
  """
  def get_consumer_key do
    Application.get_env(:mpesa_elixir, :consumer_key) || ""
  end

  @doc """
   get the certificate path from your config file
  """
  def get_certificate_path do
    Application.get_env(:mpesa_elixir, :certificate_path)
  end

  @doc """
  get customer secret key from config file
  """
  def get_consumer_secret do
    Application.get_env(:mpesa_elixir, :consumer_secret) || ""
  end

  @doc """
  create the required base64 string to use with the API
  """
  def create_base64_key do
    (get_consumer_key() <> ":" <> get_consumer_secret()) |> Base.encode64()
  end

  @doc """
  Attach a authcode here
  """
  def process_request_headers(headers) do
    Keyword.put(headers, :Authorization, "Basic #{create_base64_key()}")
  end

  @doc """
  Create a complete url to work with
  """
  def process_url(url) do
    MpesaElixir.get_api_url() <> url
  end

  @doc """
  Convert the body of the response into a %{}
  """
  @spec process_response_body(term) :: HTTPotion.Response.t()
  def process_response_body(body) do
    body |> Poison.decode!()
  end

  @doc """
  Make an http call to the API and fetch the access token
  """
  @spec generate_token() :: response
  def generate_token do
    Auth.get("/oauth/v1/generate?grant_type=client_credentials")
    |> process_response()
  end

  @doc """
  Process the response from the API
  """
  @spec process_response(HTTPotion.Response.t()) :: {:ok, %Auth{}, HTTPotion.Response.t()} | {:error, HTTPotion.Response.t()}
  def process_response(%HTTPotion.Response{status_code: status_code, body: body} = resp) do
    cond do
      status_code == 200 ->
        {:ok, %Auth{access_token: body["access_token"], expires_in: body["expires_in"]}, resp}

      true ->
        {:error, resp}
    end
  end

  @spec process_response(HTTPotion.ErrorResponse.t()) :: {:local_error, String.t()}
  def process_response(%HTTPotion.ErrorResponse{message: message}) do
    {:local_error, message}
  end

@doc """
This function will generate a securty key to use with SecurityCredential
"""
  @spec security :: String.t()
  def security do
    plain_text = "Safaricom133!"

    get_certificate_path()
    |> PublicKey.extract_public_from()
    |> PublicKey.generate_base64_cypherstring(plain_text)
  end
end
