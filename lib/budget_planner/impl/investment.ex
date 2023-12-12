defmodule BudgetPlanner.Impl.Investment do
  defstruct ~w[title type amount description expected_return ]a

  def new(%{type: type, title: title, amount: amount, expected_return: expected_return}) do
    %__MODULE__{
      type: type,
      title: title,
      amount: amount,
      expected_return: expected_return
    }
  end
end
