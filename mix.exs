defmodule Intercom.Mixfile do
  use Mix.Project

  def project do
    [
      app: :intercom,
      version: "0.0.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test
      ],
      description: "Intercom API client library",
      package: package(),
      source_url: "https://github.com/craigp/ex_intercom"
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:timex, "~> 3.1"},
      {:httpoison, "~> 0.10"},
      {:poison, "~> 2.0 or ~> 3.0"},
      {:excoveralls, "~> 0.5", only: :test},
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.13", only: :dev},
      {:dialyxir, "~> 0.3", only: :dev},
      {:credo, "~> 0.3", only: :dev},
      {:dogma, "~> 0.1", only: :dev},
      {:bypass, "~> 0.1", only: :test},
      {:inch_ex, "~> 0.5", only: :docs}
    ]
  end

  defp package do
    [
      name: "ex_intercom",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      maintainers: ["Craig Paterson"],
      links: %{"Github" => "https://github.com/craigp/ex_intercom"}
    ]
  end

end
