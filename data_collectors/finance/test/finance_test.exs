defmodule FinanceTest do
  use ExUnit.Case
  doctest Finance
  alias HTTPotion

  setup do
    gen_server_start = GenServer.start(Finance.DataCacher, %{})
    {:ok, pid} = gen_server_start
    {:ok, %{gen_pid: pid}}
  end


  test "DataCacher add", context do
    pid = context[:gen_pid]
    GenServer.cast(pid, {:usd_eur, "1"})

    response = GenServer.call(pid, :all)
    expected = %{usd_eur: "1"}

    assert response == expected
  end

  test "DataCacher add and get latest", context do
    pid = context[:gen_pid]
    GenServer.cast(pid, {:usd_eur, "1.025"})
    GenServer.cast(pid, {:usd_eur, "1"})

    response = GenServer.call(pid, :all)
    expected = %{usd_eur: "1"}

    assert response == expected
  end

  test "DataCacher several atoms", context do
    pid = context[:gen_pid]
    GenServer.cast(pid, {:usd_eur, "1.025"})
    GenServer.cast(pid, {:eur_usd, "1"})

    response = GenServer.call(pid, :all)
    expected = %{usd_eur: "1.025" , eur_usd: "1"}

    assert response == expected
  end


  test "DataCacher empty", context do
    pid = context[:gen_pid]

    response = GenServer.call(pid, :all)
    expected = %{}

    assert response == expected
  end

  # test "Patser sample" do
  #   sample_yahoo_response = ~s({"query":{"count":1,"created":"2017-07-07T20:46:01Z","lang":"en-US","diagnostics":{"publiclyCallable":"true","url":{"execution-start-time":"0","execution-stop-time":"0","execution-time":"0","content":"http://finance.yahoo.com/d/quotes.csv?e=.csv&f=c4l1&s=USDEUR=X"},"user-time":"2","service-time":"0","build-version":"2.0.149"},"results":{"row":{"col0":"EUR","col1":"0.8758"}}}})
  #   result = Finance.YahooParser.parserResult(sample_yahoo_response_unquoted)
  #
  #   expected_result = "0.8758";
  #   assert result == expected_result
  # end

end
