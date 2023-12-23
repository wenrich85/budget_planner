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
    new_budget =
      expense
      |> Expense.new()
      |> Expense.enumerate_by_frequency()
      |> IO.inspect()
      |> Enum.reduce(budget, &Budget.add_expense(&2, &1))
    reply_with_calculator(new_budget)
  end

  def handle_call(:calculate_total_income, _from, budget) do
    {:reply, BudgetCalculator.monthly_calculations(budget), budget}
  end

  def handle_call(:calculate_totals, _from, budget) do
    reply_with_calculator(budget)
  end

  def handle_call({:add_savings_percentage, savings_percentage}, _from, budget) do
    Budget.add_savings_percentage(budget, savings_percentage)
    |> reply_with_calculator()
  end

  def handle_call({:add_savings, savings}, _from, budget) do
    Budget.add_savings(budget, savings)
    |> reply_with_calculator()
  end

  def handle_call(:get_income_streams, _from, budget) do
    reply_with_list(budget, budget.income_streams)
  end

  def handle_call(:get_savings_goals, _from, budget) do
    reply_with_list(budget, budget.savings)
  end

  def handle_call(:list_expenses, _from, budget) do
    reply_with_list(budget, budget.expenses)
  end

  def via_tuple(name) do
    BudgetPlanner.Runtime.BudgetRegistry.via_tuple({__MODULE__, name})
  end

  defp reply_with_calculator(budget), do: {:reply, BudgetCalculator.monthly_calculations(budget), budget}
  defp reply_with_list(budget, list), do: {:reply, list, budget}
end
