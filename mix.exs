defmodule MpesaElixir.MixProject do
  @moduledoc """
  # MpesaElixir
  Elixir wrapper for Safricom Mpesa API
  """
  use Mix.Project

  @description """
    Elixir wrapper for Safricom Mpesa API
  """

  def project do
    [
      app: :mpesa_elixir,
      version: "0.1.1",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ],
      start_permanent: Mix.env() == :prod,
      description: @description,
      package: package(),
      deps: deps(),
      name: "MpesaElixir"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MpesaElixir.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:req, "~> 0.5.0"},
      {:typed_struct, "~> 0.3.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.5", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.18.5", only: [:dev, :test]},
      {:plug, "~> 1.15", only: [:dev, :test]},
      {:mox, "~> 1.2.0", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["John Invictus"],
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/johninvictus/mpesa_elixir"}
    ]
  end
end
