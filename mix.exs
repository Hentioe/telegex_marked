defmodule Telegex.Marked.MixProject do
  use Mix.Project
  @description "Safe Markdown parser/renderer for Telegram."

  @version "0.0.5"

  def project do
    [
      app: :telegex_marked,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      package: package(),
      name: "Telegex.Marked",
      source_url: "https://github.com/Hentioe/telegex_marked",
      docs: [
        # The main page in the docs
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Hentioe/telegex_marked"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end
