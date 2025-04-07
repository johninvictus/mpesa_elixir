defmodule MpesaElixir.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      MpesaElixir.AuthServer
    ]

    opts = [strategy: :one_for_one, name: MpesaElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
