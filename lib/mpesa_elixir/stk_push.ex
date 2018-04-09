defmodule MpesaElixir.StkPush do
  alias MpesaElixir

  def get_stk_call_back_url do
    Application.get_env(:mpesa_elixir, :stk_call_back_url)
  end

  def processrequest(
        phone_number,
        business_short_code,
        short_code,
        pass_key,
        timestamp,
        amount,
        account_reference,
        transaction_desc
      ) do
    body = %{
      "BusinessShortCode" => business_short_code,
      "Password" => :base64.encode("#{short_code}#{pass_key}#{timestamp}"),
      "Timestamp" => timestamp,
      "TransactionType" => "CustomerPayBillOnline",
      "Amount" => amount,
      "PartyA" => phone_number,
      "PartyB" => business_short_code,
      "PhoneNumber" => phone_number,
      "CallBackURL" => get_stk_call_back_url(),
      "AccountReference" => account_reference,
      "TransactionDesc" => transaction_desc
    }

    MpesaElixir.post("/stkpush/v1/processrequest", body: Poison.encode!(body))
    |> MpesaElixir.process_response()
  end

  def query(short_code, timestamp, pass_key, checkout_requestId) do
    body = %{
      "BusinessShortCode" => short_code,
      "Password" => :base64.encode("#{short_code}#{pass_key}#{timestamp}"),
      "Timestamp" => timestamp,
      "CheckoutRequestID" => checkout_requestId
    }

    MpesaElixir.post("/stkpushquery/v1/query", body: Poison.encode!(body))
    |> MpesaElixir.process_response()
  end
end
