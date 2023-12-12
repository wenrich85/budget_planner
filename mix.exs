defmodule BudgetPlanner.MixProject do
  use Mix.Project

  def project do
    [
      app: :budget_planner,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :wx, :runtime_tools, :observer],
      mod: {BudgetPlanner.Runtime.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:decimal, "~> 2.0"},
      {:timex, "~> 3.0"}
    ]
  end
end
