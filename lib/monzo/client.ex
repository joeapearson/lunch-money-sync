defmodule Monzo.Client do
  @base_url "https://api.monzo.com"

  def whoami(auth) do
    client(auth)
    |> Req.get(url: "/ping/whoami")
  end

  def list_accounts(auth) do
    client(auth)
    |> Req.get(url: "/accounts")
  end

  defp client(auth) do
    Req.new(
      base_url: @base_url,
      auth: fn -> {:bearer, Monzo.Auth.get_access_token(auth)} end
    )
  end
end
