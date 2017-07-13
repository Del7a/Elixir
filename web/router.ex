defmodule HelloPhoenix.Router do
  use HelloPhoenix.Web, :router

@doc """
Routes requests to the coresponding contorller and action
"""

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloPhoenix do
    pipe_through [:browser, :with_session] # Use the default browser stack

    get "/", PageController, :index
    get "/test", PageController, :test
    resources "/comments", CommentController
    resources "/posts", PostController
    resources "/user", UserAuthController
    get "/register", UserAuthController, :index
    get "/login", UserAuthController, :login
    post "/login", UserAuthController, :validate
    get "/current", UserAuthController, :current_user_state
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/transactions", TransactionController
  end


pipeline :with_session do
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.LoadResource
  plug HelloPhoenix.CurrentUser
end

  # Other scopes may use custom stacks.
  # scope "/api", HelloPhoenix do
  #   pipe_through :api
  # end
end
