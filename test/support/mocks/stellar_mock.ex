defmodule Incentivize.Stellar.Mock do
  @moduledoc false

  def generate_random_keypair do
    {:ok,
     %{
       "publicKey" => "GBWYIL6G65WEYUPEAE5CTHJ4K7IT3CCELNDLZE3EIJOTCHQDWAK53IT7",
       "secret" => "SAWLB6MEGXENVOV4JXCXG2A3XQCRLR6ZSEUPLWIXQVPFHPY5KW7WSSAP"
     }}
  end

  def create_fund_account(_) do
    {:ok, "GBWYIL6G65WEYUPEAE5CTHJ4K7IT3CCELNDLZE3EIJOTCHQDWAK53IT7"}
  end

  def reward_contribution(
        _fund_public_key,
        "GBDIIX7BVWB6WLYMHH22VBTC4DNVU4FURM75O374RAC4FYNN7H46VRSS",
        _amount,
        _memo_text
      ) do
    {:error, "An error occurred"}
  end

  def reward_contribution(_fund_public_key, _contributor_public_key, _amount, _memo_text) do
    {:ok, "https://horizon-testnet.stellar.org/transactions/6789"}
  end

  def add_funds_to_account(_fund_public_key, _amount, _memo_text) do
    {:ok, "https://horizon-testnet.stellar.org/transactions/12345"}
  end
end
