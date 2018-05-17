defmodule MpesaElixir.MixProject do
  use Mix.Project

  @description """
    Elixir wrapper for Safricom Mpesa API
  """

  def project do
    [
      app: :mpesa_elixir,
      version: "0.1.1",
      elixir: "~> 1.6",
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
      extra_applications: [:logger, :httpotion, :timex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.1.0"},
      {:poison, "~> 3.1"},
      {:rsa, "~> 0.0.1 "},
      {:ex_crypto, "~> 0.9.0"},
      {:timex, "~> 3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
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
