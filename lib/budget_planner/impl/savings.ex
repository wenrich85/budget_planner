defmodule BudgetPlanner.Impl.Savings do
  defstruct ~w[ title amount total_needed savings_id ]a

  def new(%{title: title, amount: amount, total_needed: total_needed}) do
    %__MODULE__{
      title: title,
      amount: amount,
      total_needed: total_needed,
      savings_id: get_savings_id(title)
    }
  end

  def get_savings_id(title) do
    title
    |> String.downcase()
    |> String.replace(" ", "")
    |> add_random_number()
  end

  defp add_random_number(title) do
    title <> "-"<>(:rand.uniform(100) |> to_string())
  end
end
