defmodule MpesaElixir.API.Behaviour do
  @moduledoc """
  Defines the behavior for the MpesaElixir.API module.

  This module defines the callback functions that must be implemented
  by modules that handle HTTP requests to the M-Pesa API.

  The primary purpose is to provide an interface for mocking during tests.
  """

  @callback request(String.t(), Keyword.t()) :: {:ok, Req.Response.t()} | {:error, term()}
end
