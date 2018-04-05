defmodule MpesaElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :mpesa_elixir,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpotion]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.1.0"}
    ]
  end
end
