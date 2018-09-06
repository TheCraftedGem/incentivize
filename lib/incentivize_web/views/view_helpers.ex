defmodule IncentivizeWeb.ViewHelpers do
  @moduledoc """
  Site-wide view functions
  """
  alias Incentivize.User

  @spec logged_in?(Plug.Conn.t()) :: boolean()
  def logged_in?(conn) do
    case conn.assigns.current_user do
      nil -> false
      %User{} -> true
    end
  end
end
