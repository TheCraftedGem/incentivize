defmodule IncentivizeWeb.LoadUser.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias IncentivizeWeb.LoadUser

  test "init" do
    assert LoadUser.init([]) == []
  end
end
