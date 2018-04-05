defmodule MpesaElixir do
  use HTTPotion.Base

  alias MpesaElixir.Auth

  @user_agent "mpesa_elixir"

  @doc """
  Create a complete url to work with
  """
  def process_url(url) do
    get_api_url() <> "/mpesa" <> url
  end

  @doc """
  get the appropriate url from the configuration files.
  """
  def get_api_url do
    Application.get_env(:mpesa_elixir, :api_url)
  end

  @doc """
  Attach a user agent parameter for all the requests
  """
  def process_request_headers(headers) do
    headers =
      Keyword.put(headers, :"User-Agent", @user_agent)
      |> Keyword.put(:"Content-Type", "application/json")

    case Auth.generate_token() do
      {:ok, %Auth{access_token: token}, _} ->
        Keyword.put(headers, :Authorization, "Bearer #{token}")

      {:error, %HTTPotion.Response{body: body}} ->
        IO.inspect("Error occured #{body}")
        headers

      {:local_error, reason} ->
        IO.puts("Error :: #{reason}")
        headers
    end
  end

  @doc """
  Convert the body of the response into a %{}
  """
  @spec process_response_body(term) :: HTTPotion.Response.t()
  def process_response_body(body) do
    body |> Poison.decode!()
  end
end
