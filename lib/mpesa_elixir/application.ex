defmodule MpesaElixir.Application do
  @moduledoc false

  use Application

  # their failure does not cause panic to the application
  @delayed_children [
    MpesaElixir.AuthServer
  ]

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: MpesaSupervisor}
    ]

    supervisoor =
      Supervisor.start_link(children, strategy: :one_for_one)

    start_delayed_children()

    supervisoor
  end

  defp start_delayed_children do
    Enum.each(@delayed_children, fn child ->
      DynamicSupervisor.start_child(MpesaSupervisor, child)
    end)
  end
end
