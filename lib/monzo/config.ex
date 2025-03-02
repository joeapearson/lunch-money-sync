defmodule Monzo.Config do
  @default_base_url "https://api.monzo.com"

  @enforce_keys [:client_id, :client_secret, :base_url]
  defstruct [:client_id, :client_secret, base_url: @default_base_url]

  def new(attrs) do
    attrs =
      attrs
      |> Keyword.validate!(
        base_url: @default_base_url,
        client_id: "",
        client_secret: ""
      )

    struct!(__MODULE__, attrs)
  end
end
