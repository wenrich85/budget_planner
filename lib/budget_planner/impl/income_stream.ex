defmodule BudgetPlanner.Impl.IncomeStream do
  defstruct ~w[source amount frequency date]a

  def new(%{source: source, amount: amount, frequency: frequency, date: date}=_income_data) do
    %__MODULE__{
      source: source,
      amount: amount,
      frequency: frequency,
      date: date
    }
  end
end
