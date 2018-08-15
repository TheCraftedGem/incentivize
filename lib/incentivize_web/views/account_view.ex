defmodule IncentivizeWeb.AccountView do
  use IncentivizeWeb, :view

  def stellar_account_creation_link(is_test_network?) do
    if is_test_network? do
      "https://www.stellar.org/laboratory/#account-creator"
    else
      "https://www.stellar.org/account-viewer/#!/"
    end
  end
end
