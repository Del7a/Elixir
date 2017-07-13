defmodule Finance.DataFetchDataSupervisor do
  use Supervisor
@moduledoc """
  Finance.DataFetchDataSupervisor is used to supervise all of
  the date fetchers and die and restart all workers
  in the event of DataCacher error
"""

  @doc """
  Starts the Supervisor and sets [name: __MODULE__]
  for easier calls and casts
  """
  def start_link do
    Supervisor.start_link(__MODULE__, [], [name: __MODULE__])
  end


  @doc """
    The strategy is one for one because the worker processes does not
    send messages between them and malfunction in one worker does not
    disturb other workers
  """
  def init([]) do
    children = [
      # Define workers and child supervisors to be supervised
      # worker(Chatbot.Worker, [arg1, arg2, arg3]),
      #worker(Finance.UsdToEuro, []),
      worker(Finance.UsdToEuro, []),
      worker(Finance.GoldToUsd, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one]
    supervise(children, opts)
  end
end
