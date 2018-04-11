defmodule Account do
  @moduledoc """
  Module to work with mpesa account
  """

  alias MpesaElixir
  alias MpesaElixir.Auth

  @doc """
  Get balance_queue_time_out_url, from the config file
  """
  def get_balance_queue_time_out_url do
    Application.get_env(:mpesa_elixir, :balance_queue_time_out_url)
  end

  @doc """
  Get balance_result_url, from the config file
  """
  def get_balance_result_url do
    Application.get_env(:mpesa_elixir, :balance_result_url)
  end

  @spec balance(integer(), String.t()) :: term
  def balance(identifier_type, remarks) do
    body = %{
      "Initiator" => MpesaElixir.get_initiator_name(),
      "CommandID" => "AccountBalance",
      "SecurityCredential" => Auth.security(),
      "PartyA" => MpesaElixir.get_short_code(),
      "IdentifierType" => identifier_type,
      "Remarks" => remarks
    }

    MpesaElixir.post("/accountbalance/v1/query", body: Poison.encode!(body))
    |> MpesaElixir.process_response()
  end
end
