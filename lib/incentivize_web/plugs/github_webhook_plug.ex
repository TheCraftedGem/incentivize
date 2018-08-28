defmodule IncentivizeWeb.GithubWebhookPlug do
  @moduledoc """
  Github Webhook plug for verifying signatures
  """

  import Plug.Conn
  require Logger
  alias Incentivize.Repositories
  alias Plug.Crypto

  def init(options) do
    options
  end

  @doc """
  Verifies secret and calls a handler with the webhook payload
  """
  def call(conn, _options) do
    payload = conn.assigns[:raw_body]

    secret = get_webhook_secret(conn.body_params)

    [signature_in_header] = get_req_header(conn, "x-hub-signature")

    if verify_signature(payload, secret, signature_in_header) do
      conn
    else
      conn
      |> send_resp(403, "Forbidden")
      |> halt()
    end
  end

  defp get_webhook_secret(parsed_body) do
    repository =
      Repositories.get_repository_by_owner_and_name(
        parsed_body["repository"]["owner"]["login"],
        parsed_body["repository"]["name"]
      )

    if is_nil(repository) do
      ""
    else
      repository.webhook_secret
    end
  end

  defp verify_signature(payload, secret, signature_in_header) do
    signature = "sha1=" <> (:crypto.hmac(:sha, secret, payload) |> Base.encode16(case: :lower))
    Crypto.secure_compare(signature, signature_in_header)
  end
end
