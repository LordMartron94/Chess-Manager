defmodule ChessManager.MixProject do
  use Mix.Project

  def project do
    [
      app: :chess_manager,
      version: "0.0.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ChessManager, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 5.0"},
      {:uuid, "~> 1.1"}
    ]
  end
end
