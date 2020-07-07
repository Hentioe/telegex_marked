defmodule Bench.MixProject do
  use Mix.Project

  def project do
    [
      app: :bench,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases() do
    [
      "bench.as_html": ["run as_html.exs"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:telegex_marked, path: "../"},
      {:earmark, "~> 1.4"},
      {:benchee, "~> 1.0"}
    ]
  end
end
