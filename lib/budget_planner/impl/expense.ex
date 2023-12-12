defmodule BudgetPlanner.Impl.Expense do
  defstruct ~w[title amount date_due frequency type bigger_debt? total_owed]a

  def new(), do: %__MODULE__{}

  def new(%{title: title, amount: amount, date_due: date_due, frequency: frequency, type: type, bigger_debt?: bigger_debt, total_owed: total_owed}=_expense_data) do
    %__MODULE__{
      title: title,
      amount: amount,
      date_due: date_due,
      frequency: frequency,
      type: type,
      bigger_debt?: bigger_debt,
      total_owed: total_owed
    }
  end
end
