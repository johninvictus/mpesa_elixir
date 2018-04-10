defmodule MpesaElixir.B2c do
  @moduledoc """
  This modeule will contain all transactions
  """
  alias MpesaElixir
  alias MpesaElixir.Auth

  @spec get_b2c_queue_time_out_url() :: String.t()
  def get_b2c_queue_time_out_url do
    Application.get_env(:mpesa_elixir, :b2c_queue_time_out_url)
  end

  @spec get_b2c_result_url() :: String.t()
  def get_b2c_result_url do
    Application.get_env(:mpesa_elixir, :b2c_result_url)
  end

  @doc """
    Command_id: use "SalaryPayment", "BusinessPayment", "PromotionPayment"
    amount: eg 200
    partyb: your number eg 254718101442

  """
  def payment_request(command_id, amount, partyb, remarks, occasion \\ nil) do
    body = %{
      "InitiatorName" => MpesaElixir.get_initiator_name(),
      "SecurityCredential" => Auth.security(),
      "CommandID" => command_id,
      "Amount" => amount,
      "PartyA" => MpesaElixir.get_b2c_short_code(),
      "PartyB" => partyb,
      "Remarks" => remarks,
      "QueueTimeOutURL" => get_b2c_queue_time_out_url(),
      "ResultURL" => get_b2c_result_url(),
      "Occasion" => occasion
    }

    MpesaElixir.post("/b2c/v1/paymentrequest", body: Poison.encode!(body))
    |> MpesaElixir.process_response()
  end
end
