defmodule Incentivize.Application do
  use Application
  alias Incentivize.StatCollector

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    statix_config = Confex.get_env(:incentivize, :statix)

    Application.put_env(:statix, Incentivize.StatCollector, statix_config)

    :ok = StatCollector.connect()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Incentivize.Repo, []),
      # Start the endpoint when the application starts
      supervisor(IncentivizeWeb.Endpoint, []),
      # Start your own worker by calling: Incentivize.Worker.start_link(arg1, arg2, arg3)
      # worker(Incentivize.Worker, [arg1, arg2, arg3]),
      supervisor(NodeJS.Supervisor, [
        [path: Path.join(File.cwd!(), "nodejs"), pool_size: 4, timeout: 60_000]
      ]),
      {Rihanna.Supervisor, [name: Rihanna.Supervisor, postgrex: Incentivize.Repo.config()]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Incentivize.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    IncentivizeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
