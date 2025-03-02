defmodule LunchMoney.Users do
  alias LunchMoney.HttpClient

  defmodule User do
    defstruct [
      :account_id,
      :api_key_label,
      :budget_name,
      :primary_currency,
      :user_email,
      :user_id,
      :user_name
    ]
  end

  @spec get_user(LunchMoney.t()) :: User.t()
  def get_user(lm) do
    case HttpClient.get_user(lm) do
      %{status: 200, body: body} ->
        %User{
          account_id: body["account_id"],
          api_key_label: body["api_key_label"],
          budget_name: body["budget_name"],
          primary_currency: body["primary_currency"],
          user_email: body["user_email"],
          user_id: body["user_id"],
          user_name: body["user_name"]
        }
    end
  end
end
