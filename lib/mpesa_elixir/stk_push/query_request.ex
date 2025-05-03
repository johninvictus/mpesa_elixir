defmodule MpesaElixir.StkPush.QueryRequest do
  @moduledoc false
  use TypedStruct
  alias MpesaElixir.Utils
  alias __MODULE__

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
      ...>   timestamp: "20231003123456",
      ...>   checkout_request_id: "ws_CO_123456789"
      ...> })
      %MpesaElixir.StkPush.QueryRequest{
        business_short_code: "174379",
        password: "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
        timestamp: "20231003123456",
        checkout_request_id: "ws_CO_123456789"
      }
  """
  def new(attrs) do
    struct(__MODULE__, attrs)
  end

  @doc """
  Converts the STK Push query request to a map format suitable for API submission.
  This function automatically generates the password and timestamp if they are not provided.
  The password is generated using the formula: Base64(BusinessShortCode + PassKey + Timestamp)
  where PassKey is configured in the application environment.
  ## Examples

      iex> request = MpesaElixir.StkPush.QueryRequest.new(%{
      ...>   business_short_code: "174379",
      ...>   checkout_request_id: "ws_CO_123456789",
      ...>   password: "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
      ...>   timestamp: "20231003123456"
      ...> })
      iex> MpesaElixir.StkPush.QueryRequest.to_api_map(request)
      %{
        "BusinessShortCode" => "174379",
        "Password" => "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
        "Timestamp" => "20231003123456",
        "CheckoutRequestID" => "ws_CO_123456789"
      }
  """
  @spec to_api_map(QueryRequest.t()) :: map()
  def to_api_map(%QueryRequest{password: password, timestamp: timestamp} = request) do
    pass_key = Application.get_env(:mpesa_elixir, :pass_key, "")

    request =
      if is_nil(password) || is_nil(timestamp) do
        timestamp = Utils.generate_timestamp()
        password = Utils.generate_password(request.business_short_code, pass_key, timestamp)

        request
        |> Map.put(:password, password)
        |> Map.put(:timestamp, timestamp)
      else
        request
      end

      Utils.to_api_map(request, special_cases: ["id"])
  end
end
