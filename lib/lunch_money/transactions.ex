defmodule LunchMoney.Transactions do
  alias LunchMoney.HttpClient

  @doc """
  Get transactions based on the provided options.
  """
  @spec list(Keyword.t()) :: {:ok, [Transaction.t()]} | {:error, any()}
  def list(opts \\ []) do
    case HttpClient.get_transactions(opts) do
      %{status: 200, body: %{"transactions" => transactions}} ->
        {:ok, transactions |> Enum.map(&Transaction.new/1)}

      %{status: status, body: body} ->
        {:error, {status, body}}
    end
  end

  @doc """
  Get a single transaction by ID.
  """
  @spec get(LunchMoney.t(), HttpClient.id(), Keyword.t()) ::
          {:ok, Transaction.t()} | {:error, any()}
  def get(lm, id, opts \\ []) do
    case HttpClient.get_transaction(lm, id, opts) do
      %{status: 200, body: transaction} ->
        {:ok, transaction}

      %{status: status, body: body} ->
        {:error, {status, body}}
    end
  end

  @doc """
  Insert new transactions.
  """
  @spec insert(LunchMoney.t(), %{transactions: [map()]}) :: {:ok, map()} | {:error, any()}
  def insert(lm, transactions_info) do
    case HttpClient.insert_transactions(lm, transactions_info) do
      %{status: 200, body: result} ->
        {:ok, result}

      %{status: status, body: body} ->
        {:error, {status, body}}
    end
  end

  @doc """
  Update an existing transaction.
  """
  @spec update(LunchMoney.t(), HttpClient.id(), map()) :: {:ok, map()} | {:error, any()}
  def update(lm, id, transaction_info) do
    case HttpClient.update_transaction(lm, id, transaction_info) do
      %{status: 200, body: result} ->
        {:ok, result}

      %{status: status, body: body} ->
        {:error, {status, body}}
    end
  end

  @doc """
  Unsplit transactions.
  """
  @spec unsplit(LunchMoney.t(), %{parent_ids: [HttpClient.id()], remove_parents: boolean() | nil}) ::
          {:ok, map()} | {:error, any()}
  def unsplit(lm, unsplit_info) do
    case HttpClient.unsplit_transactions(lm, unsplit_info) do
      %{status: 200, body: result} ->
        {:ok, result}

      %{status: status, body: body} ->
        {:error, {status, body}}
    end
  end

  @doc """
  Get a transaction group.
  """
  @spec get_group(LunchMoney.t(), HttpClient.id()) :: {:ok, map()} | {:error, any()}
  def get_group(lm, group_id) do
    case HttpClient.get_transaction_group(lm, group_id) do
      %{status: 200, body: group} ->
        {:ok, group}

      %{status: status, body: body} ->
        {:error, {status, body}}
    end
  end

  @doc """
  Create a new transaction group.
  """
  @spec create_group(LunchMoney.t(), map()) :: {:ok, map()} | {:error, any()}
  def create_group(lm, group_info) do
    case HttpClient.create_transaction_group(lm, group_info) do
      %{status: 200, body: result} ->
        {:ok, result}

      %{status: status, body: body} ->
        {:error, {status, body}}
    end
  end

  @doc """
  Delete a transaction group.
  """
  @spec delete_group(LunchMoney.t(), HttpClient.id()) :: {:ok, map()} | {:error, any()}
  def delete_group(lm, group_id) do
    case HttpClient.delete_transaction_group(lm, group_id) do
      %{status: 200, body: result} ->
        {:ok, result}

      %{status: status, body: body} ->
        {:error, {status, body}}
    end
  end
end
