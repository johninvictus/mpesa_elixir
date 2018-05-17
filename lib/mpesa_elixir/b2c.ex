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

  def get_b2c_initaitor_name do
    Application.get_env(:mpesa_elixir, :b2c_initiator_name)
  end

  @doc """
    get business code to work with b2b
  """
  def get_b2c_short_code do
    Application.get_env(:mpesa_elixir, :b2c_short_code)
  end

  @doc """
    Command_id: use "SalaryPayment", "BusinessPayment", "PromotionPayment"
    amount: eg 200
    partyb: your number eg 254718101442

  """
  def payment_request(command_id, amount, partyb, remarks, occasion \\ nil) do
    body = %{
      "InitiatorName" => get_b2c_initaitor_name(),
      "SecurityCredential" => Auth.security(),
      "CommandID" => command_id,
      "Amount" => amount,
      "PartyA" => get_b2c_short_code(),
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
