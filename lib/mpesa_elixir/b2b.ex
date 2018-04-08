defmodule MpesaElixir.B2b do
  @moduledoc """
  Function to work with b2b
  """

  alias MpesaElixir.Auth
  alias MpesaElixir

  def get_b2b_queue_time_out_url do
    Application.get_env(:mpesa_elixir, :b2b_queue_time_out_url)
  end

  def get_b2b_result_url do
    Application.get_env(:mpesa_elixir, :b2b_result_url)
  end

  def payment_request(
        command_id,
        amount,
        sender_identifier,
        partyb,
        reciever_identifier_type,
        remarks,
        account_reference
      ) do
    body = %{
      "Initiator" => MpesaElixir.get_initiator_name(),
      "SecurityCredential" => Auth.security(),
      "CommandID" => command_id,
      "Amount" => amount,
      "PartyA" => MpesaElixir.get_short_code(),
      "SenderIdentifier" => sender_identifier,
      "PartyB" => partyb,
      "RecieverIdentifierType" => reciever_identifier_type,
      "Remarks" => remarks,
      "QueueTimeOutURL" => get_b2b_queue_time_out_url(),
      "ResultURL" => get_b2b_result_url(),
      "AccountReference" => account_reference
    }

    MpesaElixir.post("//b2b/v1/paymentrequest", body: Poison.encode!(body))
    |> MpesaElixir.process_response()
  end
end
