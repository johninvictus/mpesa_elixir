defmodule MpesaElixir.MixProject do
  use Mix.Project

  @description """
    Elixir wrapper for Safricom Mpesa API
  """

  def project do
    [
      app: :mpesa_elixir,
      version: "0.2.1",
      elixir: "~> 1.8",
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
      {:httpotion, "~> 3.1.3"},
      {:poison, "~> 4.0.1"},
      {:rsa, "~> 1.0.0 "},
      {:ex_crypto, "~> 0.10.0"},
      {:timex, "~> 3.6.2"},
      {:ex_doc, ">= 0.22.1", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["erik-mocny"],
      licenses: ["Apache 2.0"],
      organization: "payout",
      links: %{"Github" => "https://github.com/payout-one/mpesa_elixir"}
    ]
  end
end
