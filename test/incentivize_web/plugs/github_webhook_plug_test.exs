defmodule IncentivizeWeb.GithubWebhookPlug.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias IncentivizeWeb.GithubWebhookPlug

  test "init" do
    assert GithubWebhookPlug.init([]) == []
  end
end
