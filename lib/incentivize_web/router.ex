defmodule IncentivizeWeb.Router do
  use IncentivizeWeb, :router
  use Plug.ErrorHandler
  alias IncentivizeWeb.{LoadUser, RequireAuth, RequireStellarKey}
  alias Plug.Conn
  @filtered_params ["password"]
  @ignore_error_routes [
    "/wp-login.php",
    "/favicon.ico"
  ]

  # ignore errors for paths that have no reason to exist
  defp handle_errors(%{request_path: request_path}, _)
       when request_path in @ignore_error_routes do
    nil
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    if Application.get_env(:rollbax, :access_token) do
      conn =
        conn
        |> Conn.fetch_cookies()
        |> Conn.fetch_query_params()

      params =
        for {key, _value} = tuple <- conn.params, into: %{} do
          if key in @filtered_params do
            {key, "[FILTERED]"}
          else
            tuple
          end
        end

      conn_data = %{
        "request" => %{
          "cookies" => conn.req_cookies,
          "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
          "user_ip" => conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
          "headers" => Enum.into(conn.req_headers, %{}),
          "params" => params,
          "method" => conn.method
        }
      }

      conn_data =
        case conn do
          %{assigns: %{current_user: %{id: id, email: email}}} ->
            conn_data
            |> Map.put("person", %{
              "id" => to_string(id),
              "email" => email
            })

          _ ->
            conn_data
        end

      Rollbax.report(kind, reason, stacktrace, %{}, conn_data)
    end
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(LoadUser)
  end

  pipeline :require_auth do
    plug(RequireAuth)
    plug(RequireStellarKey)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :github do
    plug(IncentivizeWeb.GithubWebhookPlug)
  end

  scope "/", IncentivizeWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/styleguide", IncentivizeWeb do
    pipe_through(:browser)

    get("/", StyleguideController, :index)
  end

  scope "/auth", IncentivizeWeb do
    pipe_through(:browser)

    get("/github", GithubAuthController, :index)
    get("/github/callback", GithubAuthController, :callback)
  end

  scope "/auth", IncentivizeWeb do
    pipe_through([:browser, :require_auth])

    get("/delete", GithubAuthController, :delete)
  end

  scope "/account", IncentivizeWeb do
    pipe_through([:browser, :require_auth])

    get("/", AccountController, :show)
    get("/wallet", AccountController, :wallet)
    get("/edit", AccountController, :edit)
    put("/edit", AccountController, :update)
    get("/github/sync", AccountController, :sync)
  end

  scope "/repos", IncentivizeWeb do
    pipe_through(:browser)

    get("/", RepositoryController, :index)
    get("/:owner/:name", RepositoryController, :show)
    get("/:owner/:name/contributions", ContributionController, :for_repository)
  end

  scope "/repos", IncentivizeWeb do
    pipe_through([:browser, :require_auth])

    get("/settings", RepositoryController, :settings)
    get("/:owner/:name/edit", RepositoryController, :edit)
    put("/:owner/:name/edit", RepositoryController, :update)
  end

  scope "/repos/:owner/:name/funds", IncentivizeWeb do
    pipe_through([:browser, :require_auth])

    get("/new", FundController, :new)
    post("/create", FundController, :create)
  end

  scope "/repos/:owner/:name/funds", IncentivizeWeb do
    pipe_through([:browser])

    get("/", FundController, :index)
    get("/:id", FundController, :show)
    get("/:id/contributions", ContributionController, :for_fund)
  end

  scope "/github/webhooks", IncentivizeWeb do
    pipe_through([:api, :github])

    post("/", GithubWebhookController, :handle_webhook)
  end

  # Other scopes may use custom stacks.
  # scope "/api", IncentivizeWeb do
  #   pipe_through :api
  # end
end
