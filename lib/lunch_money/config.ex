defmodule LunchMoney.Config do
  @default_base_url "https://dev.lunchmoney.app/v1"

  @enforce_keys [:access_token, :base_url]
  defstruct [:access_token, base_url: @default_base_url]

  @access_token "89747a1d38c799ef6829f4ca7cd6040fd75c5923feab54cc6c"

  def new(attrs) do
    attrs =
      attrs
      |> Keyword.validate!(base_url: @default_base_url, access_token: @access_token)

    struct!(__MODULE__, attrs)
  end
end
