defmodule Incentivize.Stellar do
  @moduledoc """
  Module for Stellar interactions.
  """
  alias Incentivize.Flags

  def public_key, do: config()[:public_key]

  # Keep this private to the module.
  defp secret, do: config()[:secret]

  def has_secret?, do: !is_nil(secret())

  def network_url, do: config()[:network_url]

  def test_network?, do: String.contains?(network_url(), "test")

  def app_fee_percentage do
    Confex.get_env(:incentivize, :app_fee_percentage)
  end

  def asset do
    {code, issuer} =
      case Confex.get_env(:incentivize, :stellar_asset) do
        nil ->
          {"XLM", nil}

        result ->
          {result[:code], result[:issuer]}
      end

    %{"code" => code, "issuer" => issuer}
  end

  def asset_display do
    %{"code" => code} = asset()
    code
  end

  defp config do
    Confex.get_env(:incentivize, __MODULE__)
  end

  defp node_js_opts do
    Confex.get_env(:incentivize, :nodejs)
  end

  @doc """
  Generates a random keypair for creating a Stellar account
  """
  @spec generate_random_keypair() :: {:ok, map()}
  def generate_random_keypair do
    {public, secret} = Stellar.KeyPair.random()

    {:ok,
     %{
       "publicKey" => public,
       "secret" => secret
     }}
  end

  @doc """
  Creates a repository fund in stellar.
  Incentivize and the supporter will both have
  permissions to transact on the fund.

  Returns the public key of the escrow account or and error in case of an error
  """
  @spec create_fund_account(binary()) :: {:ok, binary()} | {:error, binary()}
  def create_fund_account(supporter_public_key) do
    with {:ok, {escrow_public, escrow_secret}} <- generate_escrow_account_xdr(),
         {:ok, _} <- set_weights_xdr(supporter_public_key, escrow_secret) do
      {:ok, escrow_public}
    else
      error ->
        error
    end
  end

  defp generate_escrow_account_xdr do
    {escrow_public, escrow_secret} = Stellar.KeyPair.random()

    # Starting balance needed for account
    starting_balance = "2.5000000"

    {:ok, xdr} =
      make_node_call(
        {:repositoryFund, :generateEscrowAccountXDR},
        [
          network_url(),
          secret(),
          escrow_public,
          starting_balance
        ]
      )

    case Stellar.Transactions.post(xdr) do
      {:ok, _result} ->
        {:ok, {escrow_public, escrow_secret}}

      error ->
        error
    end
  end

  defp set_weights_xdr(supporter_public_key, escrow_secret) do
    {:ok, xdr} =
      make_node_call(
        {:repositoryFund, :setWeightsXDR},
        [
          network_url(),
          escrow_secret,
          supporter_public_key,
          public_key()
        ]
      )

    Stellar.Transactions.post(xdr)
  end

  @doc """
  Gives contributor the amount specified from the given fund.
  Takes the percentage identified by app_fee_percentage as well
  """
  @spec reward_contribution(binary(), binary(), Decimal.t(), binary()) ::
          {:ok, binary()} | {:error, binary()}
  def reward_contribution(fund_public_key, contributor_public_key, amount, memo_text) do
    app_fee =
      if Flags.enable_pricing?() do
        amount
        |> Decimal.mult(Decimal.from_float(app_fee_percentage()))
        |> Decimal.to_string()
      else
        nil
      end

    {:ok, transaction_xdr} =
      make_node_call(
        {:repositoryFund, :rewardContributionXDR},
        [
          network_url(),
          secret(),
          fund_public_key,
          contributor_public_key,
          Decimal.to_string(amount),
          app_fee,
          asset(),
          memo_text
        ]
      )

    case Stellar.Transactions.post(transaction_xdr) do
      {:ok, result} ->
        {:ok, get_in(result, ["_links", "transaction", "href"])}

      error ->
        error
    end
  end

  @spec add_funds_to_account(binary(), Decimal.t(), binary()) :: {:error, map()} | {:ok, map()}
  def add_funds_to_account(fund_public_key, amount, memo_text) do
    {:ok, xdr} =
      make_node_call(
        {:repositoryFund, :addFundsXDR},
        [
          network_url(),
          secret(),
          fund_public_key,
          Decimal.to_string(amount),
          asset(),
          memo_text
        ]
      )

    Stellar.Transactions.post(xdr)
  end

  @spec create_account(binary(), Decimal.t(), binary()) :: {:error, map()} | {:ok, map()}
  def create_account(account_public_key, amount, memo_text) do
    {:ok, xdr} =
      make_node_call(
        {:repositoryFund, :createAccountXDR},
        [
          network_url(),
          secret(),
          account_public_key,
          Decimal.to_string(amount),
          memo_text
        ]
      )

    Stellar.Transactions.post(xdr)
  end

  # Indirect to nodejs process in order to capture
  # any process-level errors
  defp make_node_call(func, args) do
    try do
      NodeJS.call(func, args, node_js_opts())
    catch
      :exit, _value ->
        {:error, "node_process_exited"}
    end
  end
end
