defmodule LunchMoneySync.TransactionImporter do
  @moduledoc """
  Handles the core business logic of importing transactions from Monzo to LunchMoney.
  """

  alias LunchMoney.Transactions.Transaction, as: LunchMoneyTransaction
  alias Monzo.Transactions.Transaction, as: MonzoTransaction

  def handle_monzo_transaction_created(data) do
  end

  @doc """
  Imports a single Monzo transaction into LunchMoney.

  Returns {:ok, lunch_money_transaction} on success
  Returns {:error, reason} on failure
  """
  @spec import_transaction(%MonzoTransaction{}) ::
          {:ok, %LunchMoneyTransaction{}} | {:error, term()}
  def import_transaction(%MonzoTransaction{} = monzo_transaction) do
    with {:ok, lunch_money_params} <- convert_transaction(monzo_transaction),
         {:ok, lunch_money_transaction} <-
           LunchMoney.Transactions.insert(lunch_money_params) do
      {:ok, lunch_money_transaction}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Converts a Monzo transaction into LunchMoney transaction parameters.
  """
  @spec convert_transaction(%MonzoTransaction{}) :: {:ok, map()} | {:error, term()}
  def convert_transaction(%MonzoTransaction{} = transaction) do
    # Note: We'll need to adjust field mappings based on actual struct definitions
    params = %{
      # date should be in YYYY-MM-DD format for LunchMoney
      date: Date.to_string(transaction.created),
      # Amount in smallest currency unit (pennies/cents) needs to be converted to decimal
      amount: transaction.amount / 100,
      currency: transaction.currency,
      # Use merchant name if available, otherwise description
      payee: transaction.merchant_name || transaction.description,
      notes: build_notes(transaction),
      # Store Monzo transaction ID to prevent duplicates
      external_id: transaction.id
    }

    {:ok, params}
  end

  defp build_notes(transaction) do
    [
      "Imported from Monzo",
      "Category: #{transaction.category}",
      transaction.notes,
      "Transaction ID: #{transaction.id}"
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("\n")
  end
end
