defmodule MpesaElixir do
  use HTTPotion.Base

  @user_agent "mpesa_elixir"

  @doc """
  Create a complete url to work with
  """
  def process_url(url) do
    get_api_url() <> url
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
    Keyword.put(headers, :"User-Agent", @user_agent)
  end

  @doc """
  Convert the body of the response into a %{}
  """
  @spec process_response_body(term) :: HTTPotion.Response.t()
  def process_response_body(body) do
    body |> Poison.decode!()
  end
end
