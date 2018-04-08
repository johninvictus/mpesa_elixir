defmodule MpesaElixir.C2b do
  @moduledoc """
  This module will contain all the functions to carry out customer to business logic
  """
  alias MpesaElixir

  @doc """
  Get the confirmation url from the config file
  """
  def get_confirmation_url do
    Application.get_env(:mpesa_elixir, :confirmation_url)
  end

  @doc """
  Get the validation url from the config file
  """
  def get_validation_url do
    Application.get_env(:mpesa_elixir, :validation_url)
  end

  @doc """
  get the response type from the config
  """
  def get_response_type do
    Application.get_env(:mpesa_elixir, :response_type)
  end

  def register_callbacks do
    body = %{
      "ResponseType" => get_response_type(),
      "ConfirmationURL" => get_confirmation_url(),
      "ValidationURL" => get_validation_url(),
      "ShortCode" => MpesaElixir.get_short_code()
    }

    MpesaElixir.post("/c2b/v1/registerurl", body: Poison.encode!(body))
  end

  @doc """
   Msisdn - should have no + before the number country code
   amount - should have cent. ie 200.00
  """
  def simulate(msisdn, amount, unique_reference) do
    body = %{
      "ShortCode" => MpesaElixir.get_short_code(),
      "CommandID" => "CustomerPayBillOnline",
      "Amount" => amount,
      "Msisdn" => msisdn,
      "BillRefNumber" => unique_reference
    }

    MpesaElixir.post("/c2b/v1/simulate", body: Poison.encode!(body))
    |> MpesaElixir.process_response()
  end
end
