defprotocol LunchMoney.Transactions.Transactable do
  @spec transaction(any()) :: LunchMoney.Transactions.Transaction.t()
  def transaction(attrs)
end

defimpl LunchMoney.Transactions.Transactable, for: Map do
  def transaction(attrs) do
    %LunchMoney.Transactions.Transaction{
      id: attrs["id"],
      date: date(attrs["date"]),
      payee: attrs["payee"],
      amount: decimal(attrs["amount"]),
      currency: attrs["currency"],
      to_base: decimal(attrs["to_base"]),
      category_id: attrs["category_id"],
      category_name: attrs["category_name"],
      category_group_id: attrs["category_group_id"],
      category_group_name: attrs["category_group_name"],
      is_income: attrs["is_income"],
      exclude_from_budget: attrs["exclude_from_budget"],
      exclude_from_totals: attrs["exclude_from_totals"],
      created_at: datetime(attrs["created_at"]),
      updated_at: datetime(attrs["updated_at"]),
      status: attrs["status"],
      is_pending: attrs["is_pending"],
      notes: attrs["notes"],
      original_name: attrs["original_name"],
      recurring_id: attrs["recurring_id"],
      recurring_payee: attrs["recurring_payee"],
      recurring_description: attrs["recurring_description"],
      recurring_cadence: attrs["recurring_cadence"],
      recurring_type: attrs["recurring_type"],
      recurring_amount: attrs["recurring_amount"],
      recurring_currency: attrs["recurring_currency"],
      parent_id: attrs["parent_id"],
      has_children: attrs["has_children"],
      group_id: attrs["group_id"],
      is_group: attrs["is_group"],
      asset_id: attrs["asset_id"],
      asset_institution_name: attrs["asset_institution_name"],
      asset_name: attrs["asset_name"],
      asset_display_name: attrs["asset_display_name"],
      asset_status: attrs["asset_status"],
      plaid_account_id: attrs["plaid_account_id"],
      plaid_account_name: attrs["plaid_account_name"],
      plaid_account_mask: attrs["plaid_account_mask"],
      institution_name: attrs["institution_name"],
      plaid_account_display_name: attrs["plaid_account_display_name"],
      plaid_metadata: plaid_metadata(attrs["plaid_metadata"]),
      source: attrs["source"],
      display_name: attrs["display_name"],
      display_notes: attrs["display_notes"],
      account_display_name: attrs["account_display_name"],
      tags: attrs["tags"],
      children: children(attrs["children"]),
      external_id: attrs["external_id"]
    }
  end

  defp children(children) when is_list(children) do
    children |> Enum.map(&transaction/1)
  end

  defp children(_), do: []

  defp date(d) when is_binary(d) do
    Date.from_iso8601!(d)
  end

  defp datetime(d) when is_binary(d) do
    {:ok, dt, _} = DateTime.from_iso8601(d)

    dt
  end

  defp decimal(d) when is_float(d) do
    Decimal.from_float(d)
  end

  defp decimal(d) do
    Decimal.new(d)
  end

  defp plaid_metadata(m) when is_binary(m) do
    JSON.decode(m)
  end

  defp plaid_metadata(_), do: nil
end
