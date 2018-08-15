defmodule IncentivizeWeb.AccountViewTest do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias IncentivizeWeb.AccountView

  test "stellar_account_creation_link" do
    assert AccountView.stellar_account_creation_link(true) ==
             "https://www.stellar.org/laboratory/#account-creator"

    assert AccountView.stellar_account_creation_link(false) ==
             "https://www.stellar.org/account-viewer/#!/"
  end
end
