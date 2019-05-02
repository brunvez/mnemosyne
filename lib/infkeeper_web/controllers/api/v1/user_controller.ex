defmodule InfkeeperWeb.Api.V1.UserController do
  use InfkeeperWeb, :controller

  alias Infkeeper.Accounts
  alias Infkeeper.Accounts.User

  action_fallback InfkeeperWeb.FallbackController

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

  defp current_user(conn) do
    conn.assigns.current_user
  end
end
