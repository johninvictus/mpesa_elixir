defmodule MpesaElixir.Application do
  @moduledoc false

  use Application

  alias MpesaElixir.StkPush.MpesaSupervisor

  def start(_type, _args) do
    dont_start_in_test =
      if Application.get_env(:mpesa_elixir, :env) == :test do
        []
      else
        [MpesaSupervisor]
      end

    children = [] ++ dont_start_in_test

    # Start the supervisor first
    {:ok, supervisor} =
      Supervisor.start_link(children,
        strategy: :one_for_one,
        name: MpesaElixir.Supervisor
      )

    # Start AuthServer as a child process of the dynamic supervisor
    MpesaSupervisor.start_child({MpesaElixir.AuthServer, []})

    {:ok, supervisor}
  end
end
