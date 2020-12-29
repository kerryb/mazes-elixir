defmodule Mazes.MixProject do
  use Mix.Project

  def project do
    [
      app: :mazes,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_options: elixirc_options(Mix.env()),
      consolidate_protocols: Mix.env() != :dev,
      preferred_cli_env: preferred_cli_env(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: dialyzer(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_options(:test), do: []
  defp elixirc_options(_env), do: [warnings_as_errors: true]

  defp preferred_cli_env do
    [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.html": :test
    ]
  end

  defp dialyzer do
    [
      plt_add_deps: :app_tree,
      ignore_warnings: "config/dialyzer.ignore-warnings"
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ~w(README.md),
      source_url_pattern: "https://github.com/kerryb/mazes-elixir/blob/master/%{path}#L%{line}"
    ]
  end

  defp deps do
    [
      {:assert_value, "~> 0.9", only: [:dev, :test]},
      {:briefly, "~> 0.3", only: [:test]},
      {:credo, "~> 1.3", only: [:dev, :test]},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.21", only: :dev}
    ]
  end
end
