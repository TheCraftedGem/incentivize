defmodule Incentivize.Github.OAuth do
  use OAuth2.Strategy
  alias OAuth2.Client
  alias OAuth2.Strategy.AuthCode

  def client do
    config = Confex.get_env(:incentivize, :github, [])

    Client.new(
      strategy: __MODULE__,
      client_id: Keyword.get(config, :client_id),
      client_secret: Keyword.get(config, :client_secret),
      site: "https://api.github.com",
      authorize_url: "https://github.com/login/oauth/authorize",
      token_url: "https://github.com/login/oauth/access_token"
    )
  end

  def authorize_url! do
    Client.authorize_url!(client(), scope: "read:user,user:email")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    Client.get_token!(client(), params, headers, opts)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
