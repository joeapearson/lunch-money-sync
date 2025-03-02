defmodule Monzo.Auth do
  @moduledoc """
  Manages Monzo authentication
  """

  use GenServer
  require Logger

  def init_authz_code_flow(redirect_uri) do
    GenServer.call(__MODULE__, {:init_authz_code_flow, redirect_uri})
  end

  def handle_authorization_code(authz_code, state) do
    GenServer.cast(__MODULE__, {:handle_authz_code, authz_code, state})
  end

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    state = %{
      access_token: nil,
      oauth2_state: nil,
      oauth2_redirect_uri: nil,
      refresh_token: nil
    }

    {:ok, state}
  end

  @impl true
  def handle_call({:init_authz_code_flow, redirect_uri}, _from, state) do
    oauth2_state = generate_oauth2_state()

    authorization_url =
      "https://auth.monzo.com/?client_id=#{client_id()}&redirect_uri=#{redirect_uri}&response_type=code&state=#{oauth2_state}"

    {:reply, authorization_url,
     %{state | oauth2_state: oauth2_state, oauth2_redirect_uri: redirect_uri}}
  end

  @impl true
  def handle_cast(
        {:handle_authz_code, authorization_code, received_oauth2_state},
        %{
          oauth2_state: specified_oauth2_state,
          oauth2_redirect_uri: oauth2_redirect_uri
        } = state
      )
      when received_oauth2_state == specified_oauth2_state do
    # TODO move this to Monzo API
    %{
      status: 200,
      body: %{
        "access_token" => access_token,
        # "client_id" => client_id,
        # "expires_in" => expires_in,
        "refresh_token" => refresh_token
        # "scope" => scope
        # "token_type" => token_type,
        # "user_id" => user_id
      }
    } =
      Req.post!("https://api.monzo.com/oauth2/token",
        form: %{
          grant_type: "authorization_code",
          client_id: client_id(),
          client_secret: client_secret(),
          redirect_uri: oauth2_redirect_uri,
          code: authorization_code
        }
      )

    {:noreply,
     %{
       state
       | oauth2_state: nil,
         oauth2_redirect_uri: nil,
         access_token: access_token,
         refresh_token: refresh_token
     }}
  end

  defp config() do
    Application.get_env(:lunch_money_sync, __MODULE__, [])
  end

  defp client_id() do
    config() |> Keyword.fetch!(:client_id)
  end

  defp client_secret() do
    config() |> Keyword.fetch!(:client_secret)
  end

  defp generate_oauth2_state() do
    :crypto.strong_rand_bytes(16) |> Base.encode64()
  end
end
