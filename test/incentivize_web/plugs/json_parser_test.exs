defmodule IncentivizeWeb.Parsers.JSON.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias IncentivizeWeb.Parsers.JSON

  describe "init" do
    test "errors when no JSON Parser given" do
      assert_raise ArgumentError, fn ->
        JSON.init([])
      end
    end

    test "returns decoder and options" do
      assert {Jason, []} = JSON.init(json_decoder: Jason)
    end
  end
end
