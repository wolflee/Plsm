defmodule Plsm.Mixfile do
  use Mix.Project

  def project do
    [app: :plsm,
     version: "2.0.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:postgrex, :mariaex]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:mariaex, "~> 0.8.0"},
      {:postgrex, "~> 0.13.0"},
      {:mock, "~> 0.2.0", only: :test},
      {:inflex, "~> 1.8.1"},
    ]
  end

  defp description do
    """
      Plsm generates Ecto models based on existing database tables and populates the fields of the model.
    """
  end

  defp package do
    [
     name: :plsm,
     files: ["lib","mix.exs", "README.md", "LICENSE"],
     maintainers: ["Jon Hartwell"],
     licenses: ["MIT License"],
     links: %{"GitHub" => "https://github.com/jhartwell/Plsm"}
    ]
  end
end
