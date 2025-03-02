defmodule LunchMoneySync do
  @moduledoc """
  Documentation for `LunchMoneySync`.
  """

  defimpl LunchMoney.Transactions.Transactable, for: Monzo.Transaction do
    def transaction(%Monzo.Transactions.Transaction{}) do
    end
  end
end
