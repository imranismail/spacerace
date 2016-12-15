defmodule Spacerace.Mixfile do
  use Mix.Project

  def project do
    [app: :spacerace,
     version: "0.1.0",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :poison, :httpoison, :ecto, :plug],
     mod: {Spacerace.Application, []}]
  end

  defp description do
    """
    The flexible REST API client
    """
  end

  defp package do
    [name: :spacerace,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Imran Ismail"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/127labs/spacerace"}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.10.0"},
     {:poison, "~> 2.0"},
     {:ecto, "~> 2.1.0-rc.5", optional: true},
     {:plug, "~> 1.3", optional: true},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
