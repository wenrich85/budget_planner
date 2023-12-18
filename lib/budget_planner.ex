defmodule BudgetPlanner do

  def start_budget(name) do
    case BudgetPlanner.Runtime.Application.start_budget(name) do
      {:ok, planner} -> planner
      {:error, {:already_started, planner}} -> planner
    end
  end

  def add_income_stream(name, income_data) do
    GenServer.call(via_tuple(name), {:add_income_stream, income_data})
  end

  def add_expense(name, expense) do
    GenServer.call(via_tuple(name), {:add_expense, expense})
  end

  def calculate_total_expenses(name) do
    GenServer.call(via_tuple(name), :calculate_expenses)
  end

  def calculate_totals(name) do
    GenServer.call(via_tuple(name), :calculate_totals)
  end

  def get_state(name) do
    :sys.get_state(via_tuple(name))
  end

  defp via_tuple(name) do
    BudgetPlanner.Runtime.BudgetRegistry.via_tuple({BudgetPlanner.Runtime.DebtManager, name})
  end
end
