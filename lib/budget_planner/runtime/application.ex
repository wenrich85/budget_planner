defmodule BudgetPlanner.Runtime.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  @super_name BudgetStarter
  @impl true
  def start(_type, _args) do
    supervisor_spec = [
       BudgetPlanner.Runtime.BudgetRegistry,
      {DynamicSupervisor, strategy: :one_for_one, name: @super_name}

    ]


    Supervisor.start_link(supervisor_spec, strategy: :one_for_one)
  end

  def start_budget(name) do
    DynamicSupervisor.start_child(@super_name, {BudgetPlanner.Runtime.DebtManager, name})
  end
end
