defmodule MpesaElixir.Transaction do

  alias MpesaElixir.Auth

  def get_status_queue_time_out_url do
    Application.get_env(:mpesa_elixir, :status_queue_time_out_url)
  end

  def get_status_result_url do
    Application.get_env(:mpesa_elixir, :status_result_url)
  end

  def get_reversal_queue_time_out_url do
    Application.get_env(:mpesa_elixir, :reversal_queue_time_out_url)
  end

  def get_reversal_result_url do
    Application.get_env(:mpesa_elixir, :reversal_result_url)
  end


  def status(transaction_id, identifier_type, remarks, occasion \\ nil) do
    body = %{
      "Initiator" => MpesaElixir.get_initiator_name(),
      "SecurityCredential" => Auth.security(),
      "CommandID" => "TransactionStatusQuery",
      "TransactionID" => transaction_id,
      "PartyA" => MpesaElixir.get_short_code(),
      "IdentifierType" => identifier_type,
      "ResultURL" => get_status_result_url(),
      "QueueTimeOutURL" => get_status_queue_time_out_url(),
      "Remarks" => remarks,
      "Occasion" => occasion
    }

    MpesaElixir.post("/transactionstatus/v1/query", body: Poison.encode!(body))
    |> MpesaElixir.process_response()
  end

  def reverse(transaction_id, amount, receiver_party, reciever_identifier_type, remarks, occasion \\ nil) do
    body = %{
      "Initiator" => MpesaElixir.get_initiator_name(),
      "SecurityCredential" => Auth.security(),
      "CommandID" => "TransactionReversal",
      "TransactionID" => transaction_id,
      "Amount" => amount,
      "ReceiverParty" => receiver_party,
      "RecieverIdentifierType" => reciever_identifier_type,
      "ResultURL" => get_reversal_result_url(),
      "QueueTimeOutURL" => get_reversal_queue_time_out_url(),
      "Remarks" => remarks,
      "Occasion" => occasion
    }

    MpesaElixir.post("/reversal/v1/request", body: Poison.encode!(body))
    |> MpesaElixir.process_response()
  end
end
