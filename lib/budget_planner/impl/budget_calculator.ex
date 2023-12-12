defmodule BudgetPlanner.Impl.BudgetCalculator do
  defstruct ~w[monthly_income monthly_expenses monthly_saving total_debt total_savings_needed current_savings percentage_used amount_remaining]a

  def monthly_calculations(budget) do
    %__MODULE__{}
    |> struct!(monthly_income: calculate_monthly_income(budget.income_streams))
    |> struct!(monthly_expenses: calculate_monthly_expenses(budget.expenses))
    |> savings_percentage()
    |> struct!(current_savings: budget.savings)
    |> calculate_savings_needed()
    |> expense_percentage()
    |> calc_remaining()
    |> struct!(total_debt: total_debt_calc(budget))
  end

  def calculate_monthly_income(income_streams) do
    monthly_calc(income_streams) + weekly_calc(income_streams) + biweekly_calc(income_streams) + hourly_calc(income_streams)
  end

  def calculate_monthly_expenses(monthly_expenses) do
    Enum.reduce(monthly_expenses, 0, &(&1.amount + &2))
  end

  def calculate_savings_needed(budget_calc) do
    struct!(budget_calc, total_savings_needed: budget_calc.monthly_expenses * 6)
  end

  def savings_percentage(budget_calc) do
    struct!(budget_calc, monthly_saving: budget_calc.monthly_income * 0.25)
  end

  def calc_remaining(budget_calc) do
    struct!(budget_calc, amount_remaining: budget_calc.monthly_income - budget_calc.monthly_expenses - budget_calc.monthly_saving)
  end

  def total_debt_calc(budget) do
    Enum.filter(budget.expenses, &(&1.bigger_debt?))
    |> Enum.reduce(0, &(&1.total_owed + &2))
  end

  def investment_percentage do

  end

  def waste_percentage do

  end

  def expense_percentage(budget_calc) do
    struct!(budget_calc,
      percentage_used:
      budget_calc.monthly_expenses / budget_calc.monthly_income * 100
      |> ceil)
  end

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
    |> Enum.reduce(0, &(&1.amount * 40 * 2 + &2))
  end

  defp weekly_calc(income_streams) do
    Enum.filter(income_streams, &(get_pay_schedule(&1.frequency, "weekly")))
    |> Enum.reduce(0, &(&1.amount * 4.5 + &2))

  end

  def get_pay_schedule(schedule, frequency), do: schedule == frequency

end
