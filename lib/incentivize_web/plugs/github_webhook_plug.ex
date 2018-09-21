defmodule IncentivizeWeb.GithubWebhookPlug do
  @moduledoc """
  GitHub Webhook plug for verifying signatures
  """

  import Plug.Conn
  require Logger

  def init(options) do
    options
  end

  @doc """
  Verifies secret and calls a handler with the webhook payload
  """
  def call(conn, _options) do
    payload = conn.assigns[:raw_body]

    secret = Confex.get_env(:incentivize, Incentivize.Github.App, [])[:webhook_secret]

    [signature_in_header] = get_req_header(conn, "x-hub-signature")

    if verify_signature(payload, secret, signature_in_header) do
      conn
    else
      conn
      |> send_resp(403, "Forbidden")
      |> halt()
    end
  end

  defp verify_signature(payload, secret, signature_in_header) do
    signature = "sha1=" <> (:crypto.hmac(:sha, secret, payload) |> Base.encode16(case: :lower))
    Plug.Crypto.secure_compare(signature, signature_in_header)
  end
end
