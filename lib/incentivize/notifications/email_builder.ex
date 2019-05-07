defmodule Incentivize.EmailBuilder do
  import Bamboo.Email
  use Bamboo.Phoenix, view: IncentivizeWeb.EmailView

  def email_verification_email(user, email, token) do
    base_email()
    |> assign(:user, user)
    |> assign(:token, token)
    |> to(email)
    |> subject("Verify your email address")
    |> render("verify_email.html")
  end

  defp base_email do
    new_email()
    |> from("noreply@incentivize.io")
    |> put_html_layout({IncentivizeWeb.LayoutView, "email.html"})
  end
end
