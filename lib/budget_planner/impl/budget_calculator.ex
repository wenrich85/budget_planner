defmodule BudgetPlanner.Impl.BudgetCalculator do
  defstruct ~w[monthly_income monthly_expenses monthly_saving total_debt total_savings_needed current_savings percentage_used amount_remaining]a

  def monthly_calculations(budget) do
    income = calculate_monthly_income(budget.income_streams)
    expenses = calculate_monthly_expenses(budget.expenses)
    %__MODULE__{}
    |> struct!(monthly_income: income)
    |> struct!(monthly_expenses: expenses)
    |> struct!( monthly_saving: savings_percentage(income))
    |> struct!(current_savings: budget.savings)
    |> struct!(total_savings_needed: calculate_savings_needed(expenses))
    |> struct!(percentage_used: expense_percentage(expenses, income))
    |> struct!(amount_remaining: calc_remaining(income, expenses))
    |> struct!(total_debt: total_debt_calc(budget.expenses))
  end

  def calculate_monthly_income(income_streams) do
    monthly_calc(income_streams) + weekly_calc(income_streams) + biweekly_calc(income_streams) + hourly_calc(income_streams)
  end

  def calculate_monthly_expenses(monthly_expenses) do
    Enum.reduce(monthly_expenses, 0, &(&1.amount + &2))
  end

  def calculate_savings_needed(monthly_expenses) do
    monthly_expenses * 6
  end

  def savings_percentage(income) do
    income * 0.25
  end

  def calc_remaining(monthly_income, monthly_expenses) do
    monthly_income - monthly_expenses - savings_percentage(monthly_income)
  end

  def calc_remaining(budget_calc), do: budget_calc

  def total_debt_calc(expenses) do
    Enum.filter(expenses, &(&1.bigger_debt?))
    |> bigger_debt_calc()
  end

  def bigger_debt_calc(list_of_debts) when length(list_of_debts) > 0, do: Enum.reduce(list_of_debts, 0, &(&1.total_owed + &2))
  def bigger_debt_calc(_), do: 0

  def investment_percentage do

  end

  def waste_percentage do

  end

  def expense_percentage(monthly_expenses, monthly_income) when monthly_income > 0 do
    monthly_expenses / monthly_income * 100
      |> ceil
  end

  def expense_percentage(_, _), do: 0

  defp monthly_calc(income_streams) do
    Enum.filter(income_streams, &(get_pay_schedule(&1.frequency, "monthly")))
    |> Enum.reduce(0, &(&1.amount + &2))
  end

  defp biweekly_calc(income_streams) do
    Enum.filter(income_streams, &(get_pay_schedule(&1.frequency, "bi-weekly")))
    |> Enum.reduce(0, &(&1.amount * 2 + &2))
  end

  defp hourly_calc(income_streams) do
    Enum.filter(income_streams, &(get_pay_schedule(&1.frequency, "hourly")))
    |> Enum.reduce(0, &(&1.amount * 40 * 5 * 4.5 + &2))
  end

  defp weekly_calc(income_streams) do
    Enum.filter(income_streams, &(get_pay_schedule(&1.frequency, "weekly")))
    |> Enum.reduce(0, &(&1.amount * 4.5 + &2))

  end

  def get_pay_schedule(schedule, frequency), do: schedule == frequency

end
