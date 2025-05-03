defmodule MpesaElixir.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    dont_start_in_test =
      if Application.get_env(:mpesa_elixir, :env)  == :test do
        []
      else
        [MpesaElixir.AuthServer]
      end

    children = [] ++ dont_start_in_test

    opts = [strategy: :one_for_one, name: MpesaElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
