defmodule IncentivizeWeb.LayoutView do
  use IncentivizeWeb, :view
  alias Incentivize.User

  def logged_in?(conn) do
    case conn.assigns.current_user do
      nil -> false
      %User{} -> true
    end
  end
end
