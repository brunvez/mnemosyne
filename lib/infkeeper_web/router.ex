defmodule InfkeeperWeb.Router do
  use InfkeeperWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug InfkeeperWeb.AuthenticationPipeline
  end

  pipeline :ensure_browser_authenticated do
    plug Guardian.Plug.EnsureAuthenticated,
      error_handler: InfkeeperWeb.Authentication.BrowserErrorHandler

    plug InfkeeperWeb.Authentication.SetCurrentUser
  end

  pipeline :ensure_not_authenticated do
    plug Guardian.Plug.EnsureNotAuthenticated,
      error_handler: InfkeeperWeb.Authentication.BrowserErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug InfkeeperWeb.AuthenticationPipeline
  end

  pipeline :ensure_api_authenticated do
    plug InfkeeperWeb.AuthenticationPipeline,
      error_handler: InfkeeperWeb.Authentication.ApiErrorHandler
  end

  scope "/api/v1", InfkeeperWeb.Api.V1, as: :api_v1 do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create]
  end

  scope "/api/v1", InfkeeperWeb.Api.V1, as: :api_v1 do
    pipe_through [:api, :ensure_api_authenticated]

    resources "/user", UserController, singleton: true, only: [:show, :update]
  end

  scope "/", InfkeeperWeb do
    pipe_through :browser

    scope "/" do
      pipe_through :ensure_not_authenticated

      get "/login", SessionController, :new, as: :login
      resources "/session", SessionController, singleton: true, only: [:create]
    end

    get "/sign_up", UserController, :new, as: :sign_up
    resources "/users", UserController, only: [:create]

    scope "/" do
      pipe_through :ensure_browser_authenticated

      get "/", PageController, :index, as: :root
      resources "/session", SessionController, singleton: true, only: [:delete]
    end
  end
end
