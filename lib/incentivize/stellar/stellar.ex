defmodule Incentivize.Stellar do
  @moduledoc """
  Module for Stellar interactions.
  """

  def public_key, do: config()[:public_key]

  def secret, do: config()[:secret]

  def network_url, do: config()[:network_url]

  defp config do
    Confex.get_env(:incentivize, __MODULE__)
  end
end
