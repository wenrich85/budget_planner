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
      "bi-weekly" -> duplicate_expense(expense, 2)
      "weekly" -> [  truncated_expense(expense) | duplicate_expense(expense, 4) ]
      _ -> [ expense ]
    end
  end

  defp truncated_expense(expense) do
    struct!(expense, amount: expense.amount * @truncated_week)
    |> new()
  end

  defp duplicate_expense(expense, times) do
    Enum.reduce_while(1..times, [expense], fn _x, acc ->
      if length(acc) < times, do:
      {:cont, [ new(expense) | acc ]},
    else: {:halt, acc}
    end)
  end

  # Add date to id

  # Add days to dupliacte

end
