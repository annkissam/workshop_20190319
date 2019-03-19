defmodule Workshop.MixProject do
  use Mix.Project

  def project do
    [
      app: :workshop,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {App, []},
      extra_applications: [:logger, :httpoison]
    ]
  end

  defp deps do
    [
      {:flow, "~> 0.14"},
      {:httpoison, "~> 1.4"},
      {:jason, "~> 1.1"}
    ]
  end
end
