defmodule HelloPhoenix.SessionController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.User

  @moduledoc """
  Contorller for managing user sessions.
  """

  plug :scrub_params, "session" when action in ~w(create)a
  def new(conn, _) do
    render conn, "new.html"
  end

  @doc """
  Checks if the user provided information is pressent in the
  database and creates a session if the user is known
  """
  def create(conn, %{"session" => %{"username" => username,
                                  "password" => password}}) do

  # try to get user by unique email from DB
  user = Repo.get_by(User,  %{username: username})
  # examine the result
  result = cond do
    # if user was found and provided password hash equals to stored
    # hash
    user && :crypto.hash(:sha256, password) == user.password
      -> {:ok, login(conn, user)}
    # else if we just found the user
    user ->
      {:error, :unauthorized, conn}
    # otherwise
    true ->
      # simulate check password hash timing
      #dummy_checkpw
      {:error, :not_found, conn}
  end

  case result do
    {:ok, conn} ->
      conn
      |> put_flash(:info, "You’re now logged in!")
      |> redirect(to: page_path(conn, :index))
    {:error, _reason, conn} ->
      conn
      |> put_flash(:error, "Invalid email/password combination")
      |> render("new.html")
  end
end

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end


@doc """
Used to log out the currently signed user
"""
  def delete(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end
