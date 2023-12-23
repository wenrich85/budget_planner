defmodule BudgetPlanner.Impl.Budget do
  defstruct ~w[expenses investments savings income_streams savings_percentage]a

  def new() do
    %__MODULE__{
      expenses: [],
      savings: [],
      investments: [],
      income_streams: [],
      savings_percentage: 0
    }
  end

  def add_income_stream(budget, income_stream) do
    struct!(budget,income_streams: [ income_stream| budget.income_streams])
  end

  def delete_income_stream(budget, income_id) do
    struct!(budget, income_streams: Enum.filter(budget.income_streams, &(&1.income_id != income_id)))
  end

  def add_expense(budget, expense ) do
    struct!(budget, expenses: [ expense | budget.expenses])
  end

  def add_savings_percentage(budget, savings_percentage) do
    struct!(budget, savings_percentage: savings_percentage)
  end

  def add_savings(budget, saving) do
    struct!(budget, savings: [ saving | budget.savings ])
  end

  def add_investment( budget, investment) do
    struct!(budget, investments: [investment | budget.investments])
  end


end
