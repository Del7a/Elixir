defmodule Finance.DataCacher do
  @moduledoc """
    The module is used to hold the current exchange
    rates for the currencies and comodities that
    may be traded publicly and/or privately
  """
  use GenServer

    @doc """
    Starts the GenServer and sets [name: __MODULE__]
    for easier calls and casts
    """
    def start_link do
      GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
    end

    @doc """
      The handle_call is defined to synchronously return all the current exchange rates
      as a Map.
    """
    @spec handle_call(:all, any, %{}) :: {:reply, %{}, %{}}
    def handle_call(:all, _from, state) do
      {:reply, state, state}
    end


    # GenServer callbacks
    @doc """
      New values are added asynchronously to the state of the GenServer
    """
    @spec handle_cast({atom, float}, %{}) :: {atom, %{}}
    def handle_cast({currency, item}, state) do
      newState = Map.put(state, currency, item)
      #IO.puts newState
      {:noreply, newState}
    end
  end
