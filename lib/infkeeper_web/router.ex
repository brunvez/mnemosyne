defmodule InfkeeperWeb.Router do
  use InfkeeperWeb, :router

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

  pipeline :jwt_authenticated do
    plug InfkeeperWeb.AuthenticationPipeline
  end

  scope "/api/v1", InfkeeperWeb.Api.V1, as: :api_v1 do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create]
  end

  scope "/api/v1", InfkeeperWeb.Api.V1, as: :api_v1 do
    pipe_through [:api, :jwt_authenticated]

    resources "/user", UserController, singleton: true, only: [:show, :update]
  end

  scope "/", InfkeeperWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
