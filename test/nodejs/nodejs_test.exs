defmodule Incentivize.NodeJS.Test do
  @moduledoc false
  use Incentivize.DataCase

  test "echo" do
    assert {:ok, response} = NodeJS.call({:index, :echo}, ["hello"])
    assert response === "hello"
  end
end
