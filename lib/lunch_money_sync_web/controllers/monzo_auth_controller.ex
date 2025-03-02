defmodule LunchMoneySyncWeb.MonzoAuthController do
  use LunchMoneySyncWeb, :controller

  def init(conn, _params) do
    redirect_uri = url(~p"/api/monzo/auth/callback")
    authorization_url = Monzo.Auth.init_authz_code_flow(redirect_uri)

    # Issue a 301 redirect
    conn
    |> put_status(301)
    |> redirect(external: authorization_url)
  end

  def callback(conn, %{"code" => authz_code, "state" => state}) do
    :ok = Monzo.Auth.handle_authorization_code(authz_code, state)

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
