defmodule BudgetPlanner.Impl.Expense do
  @truncated_week 0.34524
  defstruct ~w[title amount date_due frequency type bigger_debt? total_owed expense_id]a

  def new(), do: %__MODULE__{}

  def new(%{title: title, amount: amount, date_due: date_due, frequency: frequency, type: type, bigger_debt?: bigger_debt, total_owed: total_owed}=_expense_data) do
    %__MODULE__{
      title: title,
      amount: amount,
      date_due: date_due,
      frequency: frequency,
      type: type,
      bigger_debt?: bigger_debt,
      total_owed: total_owed,
      expense_id: add_expense_id(title)
    }
  end

  def add_expense_id(source) do
    source
    |> String.downcase()
    |> String.replace(" ", "")
    |> add_random_number()
  end

  defp add_random_number(source) do
    source <> "-"<>(:rand.uniform(100) |> to_string())
  end

  def enumerate_by_frequency(expense) do
    case String.downcase(expense.frequency) do
      "bi-weekly" -> [ expense, expense ]
      "weekly" -> [ expense, expense, expense, expense, truncated_expense(expense)]
      _ -> [ expense ]
    end
  end

  defp truncated_expense(expense) do
    struct!(expense, amount: expense.amount * @truncated_week)
  end
end
