defmodule Finance.Application do
  @moduledoc """
      Initialized the Finance.Application. The applications sole purpouse is to hold
      the lates exchange rates for given currencies and comodities.
      To obtain the necessary information, periodical requests are made to
      query Yahoo Finance API for the latest exchange rates.
      The latest possible rates are stored in DataCacher and can be retrieved
      with call to the GenServer.
  """

  use Application

  @doc """
  Initializes the main application
  """
  def init([]) do

  end

  @doc """
    Starts the supervisor with :rest_for_one strategy
    in order to have the latest exchange rates.
    In case of DataCacher failure the DataFetchSupervisor
    will be restarted and all the child processes will fetch
    the neccessary information to the DataCacher to fill in
    the new state.
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Starts a worker by calling: Finance.Worker.start_link(arg1, arg2, arg3)
      worker(Finance.DataCacher, []),
      supervisor(Finance.DataFetchDataSupervisor, [])
      #supervisor(Finance.DataFetchSuperviser, [Finance.DataFetchSuperviser])
    ]

    opts = [strategy: :rest_for_one, name: Finance.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
