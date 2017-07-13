defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller

@moduledoc """
The main controller used to display the index page.
"""

@doc """
  Loads the index page on the web-based application
"""
  def index(conn, _params) do
    claim = Guardian.Plug.claims(conn) # Access the claims in the default location
    conn
    |> put_flash(:auth, claim)
    render conn, "index.html"
  end

end
