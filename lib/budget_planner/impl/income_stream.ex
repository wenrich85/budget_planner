defmodule BudgetPlanner.Impl.IncomeStream do
  defstruct ~w[source amount frequency date income_id]a

  def new(%{source: source, amount: amount, frequency: frequency, date: date}=_income_data) do
    %__MODULE__{
      source: source,
      amount: amount,
      frequency: frequency,
      date: date,
      income_id: add_income_id(source)
    }
  end

  def add_income_id(source) do
    source
    |> String.downcase()
    |> String.replace(" ", "")
    |> add_random_number()
  end

  defp add_random_number(source) do
    source <> "-" <> (:rand.uniform(100) |> to_string())
  end
end
