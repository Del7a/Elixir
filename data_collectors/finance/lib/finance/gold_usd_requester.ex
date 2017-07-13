defmodule Finance.GoldToUsd do
  @moduledoc """
    Queries the Yahoo Finance API for the current_user
    usd to euro exchange rate.
  """
  use GenServer
  alias HTTPotion

  @doc """
  Starts the GenServer and sets [name: __MODULE__]
  for easier calls and casts
  """
  def start_link do
      GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  @doc """
    Initializes the GenServer and schedules
    API call to be preformed immediately
  """
  def init(state) do
    schedule_work(0) # Schedule work to be performed on start
    {:ok, state}
  end

  @doc """
    Handles the Yahoo finance API call and casts the retrieved value to DataCacher
  """
  def handle_info(:work, state) do
    # Do the desired work here
    request_url = Application.get_env(:finance, :gold_to_usd_request_url)
    response = HTTPotion.get(request_url)

    value = Finance.YahooParser.parserResult(response)

    # TODO: Just for testing purposes
    #IO.puts value

    {float_value, _} = Float.parse(value)
    reverse = 1.0 / float_value

    # TODO: Just for testing purposes
    IO.puts Enum.join([:os.system_time(:millisecond), value, reverse], "   ")

    GenServer.cast(Finance.DataCacher, {:gold_usd, float_value})
    GenServer.cast(Finance.DataCacher, {:usd_gold, reverse})

    requestInterval = Application.get_env(:finance, :request_interval)
    schedule_work(requestInterval) # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work(invoke_after) do
    Process.send_after(self(), :work, invoke_after)
  end

end
