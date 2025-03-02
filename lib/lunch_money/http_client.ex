defmodule LunchMoney.HttpClient do
  @user_url "/me"
  @categories_url "/categories"
  @category_groups_url "/categories/group"
  @tags_url "/tags"
  @transactions_url "/transactions"
  @recurring_items_url "/recurring_items"
  @budgets_url "/budgets"
  @assets_url "/assets"
  @plaid_accounts_url "/plaid_accounts"
  @crypto_url "/crypto"

  @spec get_user(LunchMoney.t()) :: Req.Response.t()
  def get_user(lm) do
    lm
    |> client()
    |> Req.get!(url: @user_url)
  end

  @spec get_categories(LunchMoney.t(), format: :flattened | :nested) :: Req.Response.t()
  def get_categories(lm, opts \\ []) do
    lm
    |> client()
    |> Req.get!(url: @categories_url, params: opts)
  end

  @spec get_category(LunchMoney.t(), LunchMoney.id()) :: Req.Response.t()
  def get_category(lm, category_id) do
    lm
    |> client()
    |> Req.get!(url: "#{@categories_url}/#{category_id}")
  end

  @spec create_category(LunchMoney.t(), %{
          optional(:description) => String.t(),
          optional(:is_income) => boolean(),
          optional(:exclude_from_budget) => boolean(),
          optional(:exclude_from_totals) => boolean(),
          optional(:archived) => boolean(),
          optional(:group_id) => LunchMoney.id(),
          name: String.t()
        }) :: Req.Response.t()
  def create_category(lm, category_info) do
    lm
    |> client()
    |> Req.post!(url: @categories_url, json: category_info)
  end

  @spec update_category(LunchMoney.t(), LunchMoney.id(), %{
          optional(:description) => String.t(),
          optional(:is_income) => boolean(),
          optional(:exclude_from_budget) => boolean(),
          optional(:exclude_from_totals) => boolean(),
          optional(:archived) => boolean(),
          optional(:group_id) => LunchMoney.id(),
          optional(:name) => String.t()
        }) :: Req.Response.t()
  def update_category(lm, category_id, category_info) do
    lm
    |> client()
    |> Req.put!(url: "#{@categories_url}/#{category_id}", json: category_info)
  end

  @spec delete_category(LunchMoney.t(), LunchMoney.id()) :: Req.Response.t()
  def delete_category(lm, category_id) do
    lm
    |> client()
    |> Req.delete!(url: "#{@categories_url}/#{category_id}")
  end

  @spec delete_category_force(LunchMoney.t(), LunchMoney.id()) :: Req.Response.t()
  def delete_category_force(lm, category_id) do
    lm
    |> client()
    |> Req.delete!(url: "#{@categories_url}/#{category_id}/force")
  end

  @spec create_category_group(LunchMoney.t(), %{
          optional(:description) => String.t(),
          optional(:is_income) => boolean(),
          optional(:exclude_from_budget) => boolean(),
          optional(:exclude_from_totals) => boolean(),
          optional(:category_ids) => [LunchMoney.id()],
          optional(:new_categories) => [String.t()],
          name: String.t()
        }) :: Req.Response.t()
  def create_category_group(lm, create_category_group_info) do
    lm
    |> client()
    |> Req.post!(url: @category_groups_url, json: create_category_group_info)
  end

  @spec add_to_category_group(LunchMoney.t(), LunchMoney.id(), %{
          category_ids: [LunchMoney.id()] | nil,
          new_categories: [String.t()] | nil
        }) :: Req.Response.t()
  def add_to_category_group(lm, category_group_id, add_info) do
    lm
    |> client()
    |> Req.post!(url: "#{@category_groups_url}/#{category_group_id}/add", json: add_info)
  end

  @spec get_tags(LunchMoney.t()) :: Req.Response.t()
  def get_tags(lm) do
    lm
    |> client()
    |> Req.get!(url: @tags_url)
  end

  @spec get_transactions(LunchMoney.t(),
          tag_id: LunchMoney.id(),
          recurring_id: LunchMoney.id(),
          plaid_account_id: LunchMoney.id(),
          category_id: LunchMoney.id(),
          asset_id: LunchMoney.id(),
          is_group: boolean(),
          status: String.t(),
          start_date: String.t(),
          end_date: String.t(),
          debit_as_negative: boolean(),
          pending: boolean(),
          offset: non_neg_integer(),
          limit: non_neg_integer()
        ) :: Req.Response.t()
  def get_transactions(lm, opts \\ []) do
    lm
    |> client()
    |> Req.get!(url: @transactions_url, params: opts)
  end

  @spec get_transaction(LunchMoney.t(), LunchMoney.id(), debit_as_negative: boolean()) ::
          Req.Response.t()
  def get_transaction(lm, transaction_id, opts \\ []) do
    lm
    |> client()
    |> Req.get!(url: "#{@transactions_url}/#{transaction_id}", params: opts)
  end

  @spec insert_transactions(LunchMoney.t(), %{
          optional(:apply_rules) => boolean(),
          optional(:skip_duplicates) => boolean(),
          optional(:check_for_recurring) => boolean(),
          optional(:debit_as_negative) => boolean(),
          optional(:skip_balance_update) => boolean(),
          transactions: [
            %{
              optional(:category_id) => LunchMoney.id(),
              optional(:payee) => String.t(),
              optional(:currency) => String.t(),
              optional(:asset_id) => LunchMoney.id(),
              optional(:plaid_account_id) => LunchMoney.id(),
              optional(:recurring_id) => LunchMoney.id(),
              optional(:notes) => String.t(),
              optional(:status) => String.t(),
              optional(:external_id) => String.t(),
              optional(:tags) => [LunchMoney.id() | String.t()],
              date: String.t(),
              amount: number() | String.t()
            }
          ]
        }) :: Req.Response.t()
  def insert_transactions(lm, transactions_info) do
    lm
    |> client()
    |> Req.post!(url: @transactions_url, json: transactions_info)
  end

  @spec update_transaction(LunchMoney.t(), LunchMoney.id(), %{
          optional(:split) => [
            %{
              amount: number(),
              category_id: LunchMoney.id(),
              payee: String.t(),
              notes: String.t() | nil,
              tags: [LunchMoney.id() | String.t()] | nil
            }
          ],
          optional(:transaction) => %{
            optional(:category_id) => LunchMoney.id(),
            optional(:payee) => String.t(),
            optional(:currency) => String.t(),
            optional(:asset_id) => LunchMoney.id(),
            optional(:plaid_account_id) => LunchMoney.id(),
            optional(:recurring_id) => LunchMoney.id(),
            optional(:notes) => String.t(),
            optional(:status) => String.t(),
            optional(:external_id) => String.t(),
            optional(:tags) => [LunchMoney.id() | String.t()],
            optional(:date) => String.t(),
            optional(:amount) => number() | String.t(),
            id: LunchMoney.id()
          },
          optional(:debit_as_negative) => boolean(),
          optional(:skip_balance_update) => boolean()
        }) :: Req.Response.t()
  def update_transaction(lm, transaction_id, transaction_info) do
    lm
    |> client()
    |> Req.put!(url: "#{@transactions_url}/#{transaction_id}", json: transaction_info)
  end

  @spec unsplit_transactions(LunchMoney.t(), %{
          optional(:remove_parents) => boolean(),
          parent_ids: [LunchMoney.id()]
        }) :: Req.Response.t()
  def unsplit_transactions(lm, unsplit_info) do
    lm
    |> client()
    |> Req.post!(url: "#{@transactions_url}/unsplit", json: unsplit_info)
  end

  @spec get_transaction_group(LunchMoney.t(), LunchMoney.id()) :: Req.Response.t()
  def get_transaction_group(lm, transaction_id) do
    lm
    |> client()
    |> Req.get!(url: "#{@transactions_url}/group", params: [id: transaction_id])
  end

  @spec create_transaction_group(LunchMoney.t(), %{
          optional(:category_id) => LunchMoney.id(),
          optional(:notes) => String.t(),
          optional(:tags) => [LunchMoney.id()],
          date: String.t(),
          payee: String.t(),
          transactions: [LunchMoney.id()]
        }) :: Req.Response.t()
  def create_transaction_group(lm, transaction_group_info) do
    lm
    |> client()
    |> Req.post!(url: "#{@transactions_url}/group", json: transaction_group_info)
  end

  @spec delete_transaction_group(LunchMoney.t(), LunchMoney.id()) :: Req.Response.t()
  def delete_transaction_group(lm, transaction_group_id) do
    lm
    |> client()
    |> Req.delete!(url: "#{@transactions_url}/group/#{transaction_group_id}")
  end

  @spec get_recurring_items(LunchMoney.t(),
          start_date: String.t(),
          debit_as_negative: boolean()
        ) :: Req.Response.t()
  def get_recurring_items(lm, opts \\ []) do
    lm
    |> client()
    |> Req.get!(url: @recurring_items_url, params: opts)
  end

  @spec get_budget_summary(LunchMoney.t(),
          start_date: String.t(),
          end_date: String.t(),
          currency: String.t()
        ) :: Req.Response.t()
  def get_budget_summary(lm, opts \\ []) do
    lm
    |> client()
    |> Req.get!(url: @budgets_url, params: opts)
  end

  @spec upsert_budget(LunchMoney.t(), %{
          optional(:currency) => String.t(),
          start_date: String.t(),
          category_id: LunchMoney.id(),
          amount: number()
        }) :: Req.Response.t()
  def upsert_budget(lm, budget_info) do
    lm
    |> client()
    |> Req.put!(url: @budgets_url, json: budget_info)
  end

  @spec remove_budget(LunchMoney.t(), %{
          start_date: String.t(),
          category_id: LunchMoney.id()
        }) :: Req.Response.t()
  def remove_budget(lm, remove_info) do
    lm
    |> client()
    |> Req.delete!(url: @budgets_url, params: remove_info)
  end

  # Get assets
  @spec get_assets(LunchMoney.t()) :: Req.Response.t()
  def get_assets(lm) do
    lm
    |> client()
    |> Req.get!(url: @assets_url)
  end

  # Create asset
  @spec create_asset(LunchMoney.t(), %{
          type_name: String.t(),
          subtype_name: String.t() | nil,
          name: String.t(),
          display_name: String.t() | nil,
          balance: String.t(),
          balance_as_of: String.t() | nil,
          currency: String.t() | nil,
          institution_name: String.t() | nil,
          closed_on: String.t() | nil,
          exclude_transactions: boolean() | nil
        }) :: Req.Response.t()
  def create_asset(lm, asset_info) do
    lm
    |> client()
    |> Req.post!(url: @assets_url, json: asset_info)
  end

  # Update asset
  @spec update_asset(LunchMoney.t(), LunchMoney.id(), %{
          optional(:type_name) => String.t(),
          optional(:subtype_name) => String.t(),
          optional(:name) => String.t(),
          optional(:display_name) => String.t(),
          optional(:balance) => String.t(),
          optional(:balance_as_of) => String.t(),
          optional(:currency) => String.t(),
          optional(:institution_name) => String.t(),
          optional(:closed_on) => String.t(),
          optional(:exclude_transactions) => boolean()
        }) :: Req.Response.t()
  def update_asset(lm, asset_id, asset_info) do
    lm
    |> client()
    |> Req.put!(url: "#{@assets_url}/#{asset_id}", json: asset_info)
  end

  # Get plaid accounts
  @spec get_plaid_accounts(LunchMoney.t()) :: Req.Response.t()
  def get_plaid_accounts(lm) do
    lm
    |> client()
    |> Req.get!(url: @plaid_accounts_url)
  end

  # Trigger fetch from plaid
  @spec trigger_plaid_fetch(LunchMoney.t(), %{
          optional(:start_date) => String.t(),
          optional(:end_date) => String.t(),
          optional(:plaid_account_id) => non_neg_integer()
        }) :: Req.Response.t()
  def trigger_plaid_fetch(lm, fetch_info) do
    lm
    |> client()
    |> Req.post!(url: "#{@plaid_accounts_url}/fetch", json: fetch_info)
  end

  # Get crypto
  @spec get_crypto(LunchMoney.t()) :: Req.Response.t()
  def get_crypto(lm) do
    lm
    |> client()
    |> Req.get!(url: @crypto_url)
  end

  # Update manual crypto asset
  @spec update_manual_crypto(LunchMoney.t(), LunchMoney.id(), %{
          optional(:name) => String.t(),
          optional(:display_name) => String.t(),
          optional(:institution_name) => String.t(),
          optional(:balance) => number(),
          optional(:currency) => String.t()
        }) :: Req.Response.t()
  def update_manual_crypto(lm, crypto_id, crypto_info) do
    lm
    |> client()
    |> Req.put!(url: "#{@crypto_url}/manual/#{crypto_id}", json: crypto_info)
  end

  defp client(lm) do
    Req.new(
      base_url: lm.config.base_url,
      auth: {:bearer, lm.config.access_token}
    )
  end
end
