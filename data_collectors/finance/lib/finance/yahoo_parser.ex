defmodule Finance.YahooParser do
  @moduledoc """
  Parser for the Yahoo Finance API
  """

  @doc """
  Used to parse the raw HTTP response from the Yahoo Finance API

  ## Parameters

    response: String that represents the HTTP response from the server.

  ## Examples
  Sample input from the API:
  {
	"query": {
		"count": 1,
		"created": "2017-07-07T20:46:01Z",
		"lang": "en-US",
		"diagnostics": {
			"publiclyCallable": "true",
			"url": {
				"execution-start-time": "0",
				"execution-stop-time": "0",
				"execution-time": "0",
				"content": "http://finance.yahoo.com/d/quotes.csv?e=.csv&f=c4l1&s=USDEUR=X"
			},
			"user-time": "2",
			"service-time": "0",
			"build-version": "2.0.149"
		  },"results": {
			"row": {
				"col0": "EUR",
				"col1": "0.8758"
			}
		}
	}
}
!!! Works with one row API responses ONLY !!!
  """

  @spec parserResult(String.t) :: String.t
  def parserResult(response) do
    body = Poison.Parser.parse!(response.body)
    query = Map.get(body, "query")
    results = Map.get(query, "results")
    row = Map.get(results, "row")
    Map.get(row, "col1")
  end
end
