defmodule MpesaElixir.QrCode do
  @moduledoc false
  use TypedStruct

  alias __MODULE__.Request
  alias MpesaElixir.API

  typedstruct module: Request, enforce: true do
    field(:merchant_name, String.t())
    field(:ref_no, String.t())
    field(:amount, integer())
    field(:trx_code, String.t())
    field(:cpi, String.t())
    field(:size, String.t())
  end

  @spec generate(Request.t()) :: {:ok, map()} | {:error, String.t()}
  def generate(%Request{} = request) do
    payload =
      %{
        "MerchantName" => request.merchant_name,
        "RefNo" => request.ref_no,
        "Amount" => request.amount,
        "TrxCode" => request.trx_code,
        "CPI" => request.cpi,
        "Size" => request.size
      }

    "/mpesa/qrcode/v1/generate"
    |> API.request(body: Jason.encode!(payload))
    |> API.handle_response()
  end
end
