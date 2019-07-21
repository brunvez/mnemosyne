defmodule MnemosyneWeb.Router do
  use MnemosyneWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MnemosyneWeb.AuthenticationPipeline
  end

  pipeline :ensure_browser_authenticated do
    plug Guardian.Plug.EnsureAuthenticated,
      error_handler: MnemosyneWeb.Authentication.BrowserErrorHandler

    plug MnemosyneWeb.Authentication.SetCurrentUser
  end

  pipeline :ensure_not_authenticated do
    plug Guardian.Plug.EnsureNotAuthenticated,
      error_handler: MnemosyneWeb.Authentication.BrowserErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug MnemosyneWeb.AuthenticationPipeline
  end

  pipeline :ensure_api_authenticated do
    plug MnemosyneWeb.AuthenticationPipeline,
      error_handler: MnemosyneWeb.Authentication.ApiErrorHandler

    plug MnemosyneWeb.Authentication.SetCurrentUser
  end

  scope "/api/v1", MnemosyneWeb.Api.V1, as: :api_v1 do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create]
  end

  scope "/api/v1", MnemosyneWeb.Api.V1, as: :api_v1 do
    pipe_through [:api, :ensure_api_authenticated]

    resources "/user", UserController, singleton: true, only: [:show, :update]
    resources "/memories", MemoryController, only: [:show, :create, :update]
  end

  scope "/", MnemosyneWeb do
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

      get "/", MemoryController, :index, as: :root
      resources "/session", SessionController, singleton: true, only: [:delete]
      resources "/memories", MemoryController, except: [:index]
    end
  end
end
