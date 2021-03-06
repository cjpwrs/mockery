defmodule Mockery.Mixfile do
  use Mix.Project

  @version "2.0.2"

  def project do
    [
      app: :mockery,
      deps: deps(),
      description: description(),
      dialyzer: [
        flags: [
          :error_handling, :race_conditions, :underspecs, :unmatched_returns
        ],
        plt_add_apps: [:ex_unit, :mix],
      ],
      docs: [
        extras: ["README.md", "EXAMPLES.md", "CHANGELOG.md"],
        main: "readme"
      ],
      elixir: "~> 1.1",
      elixirc_paths: elixirc_paths(Mix.env),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.json": :test
      ],
      test_coverage: [tool: ExCoveralls],
      version: @version
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:credo, "~> 0.8", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:excoveralls, "~> 0.7", only: :test, runtime: false},
      {:ex_doc, "~> 0.13", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Simple mocking library for asynchronous testing."
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp package do
    [
      name: :mockery,
      files: ~w(lib mix.exs README.md CHANGELOG.md LICENSE),
      maintainers: ["Tobiasz Małecki"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/appunite/mockery",
        "Changelog" => "https://hexdocs.pm/mockery/changelog.html"
      }
    ]
  end
end
