defmodule VideoChatWeb.Router do
  use VideoChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VideoChatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", CallController, :index
    get "/offer", CallController, :offer
    get "/answer", CallController, :answer
  end

  # Other scopes may use custom stacks.
  # scope "/api", VideoChatWeb do
  #   pipe_through :api
  # end
end
