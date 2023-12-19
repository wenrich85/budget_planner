defmodule BudgetPlanner.Runtime.DebtManager do
  alias BudgetPlanner.Impl.{Budget, IncomeStream, Expense, BudgetCalculator}
  use GenServer

  def start_link(name) do
    IO.puts("Debt manager is starting...")
    GenServer.start_link(__MODULE__, nil, name: via_tuple(name))
  end

  def init(_) do
    {:ok, Budget.new}
  end

  def handle_call({:add_income_stream, income_data}, _from, budget) do
    pay = IncomeStream.new(income_data)
    new_budget = Budget.add_income_stream(budget, pay)
    reply_with_calculator(new_budget)
  end

  def handle_call({:delete_income_stream, income_id}, _from, budget) do
    new_budget = Budget.delete_income_stream(budget, income_id)
    reply_with_calculator(new_budget)
  end

  def handle_call({:add_expense, expense}, _from, budget) do
    new_expense = Expense.new(expense)
    new_budget = Budget.add_expense(budget, new_expense)
    reply_with_calculator(new_budget)
  end

  def handle_call(:calculate_total_income, _from, budget) do
    {:reply, BudgetCalculator.monthly_calculations(budget), budget}
  end

  def handle_call(:calculate_totals, _from, budget) do
    reply_with_calculator(budget)
  end

  def via_tuple(name) do
    BudgetPlanner.Runtime.BudgetRegistry.via_tuple({__MODULE__, name})
  end

  defp reply_with_calculator(budget), do: {:reply, BudgetCalculator.monthly_calculations(budget), budget}
end
