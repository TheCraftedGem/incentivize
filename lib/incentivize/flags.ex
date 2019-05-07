defmodule Incentivize.Flags do
  @moduledoc """
  Feature flags for incentivize features
  """

  def enable_pricing? do
    config()[:pricing]
  end

  defp config do
    Application.get_env(:incentivize, :flags)
  end
end
