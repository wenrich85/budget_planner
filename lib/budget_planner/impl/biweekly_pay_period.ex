defmodule BudgetPlanner.Impl.BiweeklyPayPeriod do
  @pay_period 14
  import Timex

  defstruct ~w[pay_date source gross net deductions]a

  def create(%{pay_date: pay_date, source: source, gross: gross, net: net}) do
    %__MODULE__ {
      pay_date: pay_date,
      source: source,
      gross: gross,
      net: net,
      deductions: calcDeductions(gross, net)
    }
  end

  def calcDeductions(gross, net), do: gross - net

  def count_the_number_of_pay_periods(start_pay_date) do
    start_pay_date
    |> get_number_of_biweekly_periods()
  end

  def get_number_of_biweekly_periods(start_pay_date) do
    get_all_pay_days(start_pay_date)
    |> length()
  end

  def get_all_pay_days(first_pay_day) do
    get_previous_pay_days(first_pay_day) ++ get_future_pay_days(first_pay_day)
    |> MapSet.new()
    |> Enum.sort(&(Date.compare(&1, &2) != :lt))
    |> Enum.reverse()
  end

  def get_previous_pay_days(pay_day) do
    Date.range(pay_day, beginning_of_year(pay_day), @pay_period * -1)
    |> Enum.map(&(&1))
  end

  def get_future_pay_days(pay_day) do
    Date.range(pay_day, end_of_year(pay_day), @pay_period)
    |>Enum.map(&(&1))
  end

  def get_pay_days_by_month(pay_day, month) do
    get_all_pay_days(pay_day)
    |> Enum.filter(&(same_month?(&1, month)))
  end

  def get_number_of_pay_periods_per_month(payday) do
    Enum.reduce(1..12, %{}, &(Map.put(&2, month_name(&1)|> String.to_atom, get_pay_days_by_month(payday, &1) |> length)))
  end
  def paydays_for_nth_month(payday, month) do
    get_number_of_pay_periods_per_month(payday)[String.to_atom(month)]
  end

  defp same_month?(date, month), do: date.month == month
end
