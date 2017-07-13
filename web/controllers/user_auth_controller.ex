defmodule HelloPhoenix.UserAuthController do
  use HelloPhoenix.Web, :controller

@moduledoc """
Controller for creating users
"""

  alias HelloPhoenix.User

@doc """
Opens user registration form
"""
  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "register.html", changeset: changeset)
  end

  @doc """
  Opens user login form
  """
  def login(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "login.html", changeset: changeset)
  end

  @doc """
  Check if the user input maches existing user
  """
  def validate(conn, %{"user" => user_params})do
    #changeset = User.changeset(%User{}, user_params)
    username = Map.get(user_params, "username")
    password = Map.get(user_params, "password")
    pass_crypto = :crypto.hash(:sha256, password)

    result = Repo.get_by(User, %{username: username, password: pass_crypto})
    case result do
      :nil ->
        conn
        |> put_flash(:error, "Error. Check your username and password")
        |> redirect(to: user_auth_path(conn, :login))

      _ ->
        conn
        |> put_flash(:info, "Logged in")
        |> put_req_header("authorization", "Basic " <> Base.encode64(pass_crypto))
        |> Guardian.Plug.sign_in(result, :token, perms: %{default: Guardian.Permissions.max})
        |> Guardian.Plug.VerifySession.call([])
        |> redirect(to: page_path(conn, :index))
    end
  end


  @doc """
  Creates new user and sets the initial capital to the configured in the config.exs
  value
  """
  def create(conn, %{"user" => user_params}) do
    username = Map.get(user_params, "username")
    password = Map.get(user_params, "password")
    pass_crypto = :crypto.hash(:sha256, password)

    initial_capital = Application.get_env(:hello_phoenix, :initial_capital)

    changeset = User.changeset(%User{}, %{username: username, password: pass_crypto,
                              usd: initial_capital, euro: 0, gold: 0})

    case Repo.get_by(User, %{username: username}) do
      nil ->
        conn
        |> put_flash(:info, "User available")
        
        case Repo.insert(changeset) do
          {:ok, _} ->
            conn
            |> put_flash(:info, "User created successfully.")
            |> redirect(to: page_path(conn, :index))
          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      _ ->
      conn
      |> put_flash(:error, "The choosen username is not available")
      |> redirect(to: page_path(conn, :index))
    end
  end

@doc """
Shows the current user financial well-being
"""
  def current_user_state(conn, _) do
    user = Repo.get(User, conn.assigns.current_user.id)
    modelToShow = %{cur_usd: user.usd, cur_eur: user.euro, cur_gold: user.gold}

    render(conn , "current_state.html", transaction: modelToShow)
  end

end
