defmodule IncentivizeWeb.ErrorViewTest do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(IncentivizeWeb.ErrorView, "404.html", []) =~
             "The page requested does not exist."
  end

  test "render 500.html" do
    assert render_to_string(IncentivizeWeb.ErrorView, "500.html", []) =~
             "An unexpected error has occurred."
  end

  test "render any other" do
    assert render_to_string(IncentivizeWeb.ErrorView, "505.html", []) =~
             "An unexpected error has occurred."
  end
end
