defmodule MnemosyneWeb.Api.V1.UserController do
  use MnemosyneWeb, :controller

  alias Mnemosyne.Accounts
  alias Mnemosyne.Accounts.User

  action_fallback MnemosyneWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def show(conn, _params) do
    render(conn, "show.json", user: current_user(conn))
  end

  def update(conn, %{"user" => user_params}) do
    user = current_user(conn)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end
end
