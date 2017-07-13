defmodule Finance.UsdToEuro do
  @moduledoc """
    Queries the Yahoo Finance API for the current_user
    usd to euro exchange rate.
  """
  use GenServer, :finance
  alias HTTPotion

  @doc """
  Starts the Supervisor and sets [name: __MODULE__]
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
    #Process.send_after(self(), :work, 0)
    schedule_work(0) # Schedule work to be performed on start
    {:ok, state}
  end

  @doc """
    Handles the Yahoo finance API call and casts the retrieved value to DataCacher
  """
  def handle_info(:work, state) do
    # Do the desired work here
    request_url = Application.get_env(:finance, :usd_to_eur_request_url)
    #IO.inspect  requestUrl
    response = HTTPotion.get(request_url)

    value = Finance.YahooParser.parserResult(response)

    # TODO: Just for testin purposes
    #IO.puts Enum.join(value

    { float_value, _ } = Float.parse(value)
    reverse = 1.0 / float_value

    # TODO: Just for testin purposes
    IO.puts Enum.join([:os.system_time(:millisecond), value, reverse], "   ")

    #@spec value(String.t) :: String.t
    GenServer.cast(Finance.DataCacher, {:usd_eur, float_value})
    GenServer.cast(Finance.DataCacher, {:eur_usd, reverse})

    request_interval = Application.get_env(:finance, :request_interval)
    schedule_work(request_interval) # Reschedule once more
    {:noreply, state}
  end


  defp schedule_work(invoke_after) do
    Process.send_after(self(), :work, invoke_after) # In 60 seconds
  end

end
