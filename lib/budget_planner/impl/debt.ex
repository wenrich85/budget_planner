defmodule BudgetPlanner.Impl.Debt do
  defstruct ~w[balance payment end_date intrest_rate associated_payment]a

  def new, do: %__MODULE__{}
end
