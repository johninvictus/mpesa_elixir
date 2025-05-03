defmodule MpesaElixir.StkPush.QueryRequest do
  @moduledoc false
  use TypedStruct

  alias MpesaElixir.Utils

  typedstruct do
    @typedoc "STK Push query request parameters"

    # The organization's shortcode (Paybill or Buygoods)
    field(:business_short_code, String.t())

    # Base64 encoded string of (Shortcode+Passkey+Timestamp)
    field(:password, String.t(), enforce: false, default: nil)

    # Timestamp in format YYYYMMDDHHMMSS, if not provide will generate current timestamp
    field(:timestamp, String.t(), enforce: false, default: nil)

    # CheckoutRequestID to be queried
    field(:checkout_request_id, String.t())
  end


  @doc """
  Creates a new STK Push query request with the provided parameters.
  ## Examples

      iex> MpesaElixir.StkPush.QueryRequest.new(%{
      ...>   business_short_code: "174379",
      ...>   password: "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
      ...>   timestamp: "20160216165627",
      ...>   checkout_request_id: "ws_CO_123456789"
      ...> })
  """
  @spec new(map()) :: %__MODULE__{}
  def new(params) do
    %__MODULE__{}
    |> Map.merge(params)
    |> Map.update!(:timestamp, &Utils.generate_timestamp/0)
    |> Map.update!(:password, &Utils.generate_password(&1.business_short_code, Application.get_env(:mpesa_elixir, :pass_key), &1.timestamp))
  end

  def to_api_map(%__MODULE__{} = request) do
    %{
      "BusinessShortCode" => request.business_short_code,
      "Password" => request.password,
      "Timestamp" => request.timestamp,
      "CheckoutRequestID" => request.checkout_request_id
    }
  end

end
