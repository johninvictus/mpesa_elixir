defmodule MpesaElixir.StkPush.Request do
  @moduledoc """
  Represents a request body for the Lipa na M-PESA online API (STK Push).

  This struct contains all the required parameters for initiating a C2B payment
  through M-PESA's STK Push service, which sends a payment prompt to the
  customer's phone.
  """
  use TypedStruct
  alias MpesaElixir.Utils

  typedstruct enforce: true do
    @typedoc "STK Push request parameters"

    # The organization's shortcode (Paybill or Buygoods)
    field(:business_short_code, String.t())

    # Base64 encoded string of (Shortcode+Passkey+Timestamp)
    field(:password, String.t(), enforce: false, default: nil)

    # Timestamp in format YYYYMMDDHHMMSS, if not provide will generate current timestamp
    field(:timestamp, String.t(), enforce: false, default: nil)

    # Transaction type - CustomerPayBillOnline for PayBill or CustomerBuyGoodsOnline for Till
    field(:transaction_type, String.t())

    # Amount to be transacted (whole numbers only)
    field(:amount, String.t())

    # Phone number sending money (format: 2547XXXXXXXX)
    field(:party_a, String.t())

    # Organization receiving funds (shortcode)
    field(:party_b, String.t())

    # Mobile number to receive STK PIN prompt
    field(:phone_number, String.t())

    # Endpoint to receive transaction results
    field(:call_back_url, String.t())

    # Transaction identifier (max 12 characters)
    field(:account_reference, String.t())

    # Additional transaction information (max 13 characters)
    field(:transaction_desc, String.t())
  end

  @doc """
  Creates a new STK Push request with the provided parameters.

  ## Examples

      iex> MpesaElixir.StkPush.Request.new(%{
      ...>   business_short_code: "174379",
      ...>   password: "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
      ...>   timestamp: "20160216165627",
      ...>   transaction_type: "CustomerPayBillOnline",
      ...>   amount: "1",
      ...>   party_a: "254708374149",
      ...>   party_b: "174379",
      ...>   phone_number: "254708374149",
      ...>   call_back_url: "https://mydomain.com/path",
      ...>   account_reference: "Test",
      ...>   transaction_desc: "Test"
      ...> })
  """
  def new(attrs) do
    struct(__MODULE__, attrs)
  end

  @doc """
  Converts the struct to a map with keys formatted as required by the M-PESA API.
  This function transforms snake_case field names to PascalCase as expected by the API.

  ## Examples

      iex> request = %MpesaElixir.StkPush.Request{
      ...>   business_short_code: "174379",
      ...>   password: "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
      ...>   timestamp: "20160216165627",
      ...>   transaction_type: "CustomerPayBillOnline",
      ...>   amount: "1",
      ...>   party_a: "254708374149",
      ...>   party_b: "174379",
      ...>   phone_number: "254708374149",
      ...>   call_back_url: "https://mydomain.com/path",
      ...>   account_reference: "Test",
      ...>   transaction_desc: "Test"
      ...> }
      iex> MpesaElixir.StkPush.Request.to_api_map(request)
      %{
        "BusinessShortCode" => "174379",
        "Password" => "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
        "Timestamp" => "20160216165627",
        "TransactionType" => "CustomerPayBillOnline",
        "Amount" => "1",
        "PartyA" => "254708374149",
        "PartyB" => "174379",
        "PhoneNumber" => "254708374149",
        "CallBackURL" => "https://mydomain.com/path",
        "AccountReference" => "Test",
        "TransactionDesc" => "Test"
      }
  """
  def to_api_map(request) do
    request
    |> Map.from_struct()
    |> Enum.map(fn {k, v} -> {format_key(k), v} end)
    |> Map.new()
  end

  defp format_key(key) do
    key
    |> Atom.to_string()
    |> String.split("_")
    |> Enum.map_join(&(Utils.capitalize(&1, special_cases: ["url"])))
  end
end
