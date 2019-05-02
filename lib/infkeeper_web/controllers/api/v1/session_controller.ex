defmodule InfkeeperWeb.Api.V1.SessionController do
  use InfkeeperWeb, :controller

  alias Infkeeper.Authentication

  action_fallback InfkeeperWeb.FallbackController

  def create(conn, %{"login" => %{"email" => email, "password" => password}}) do
    case Authentication.token_sign_in(email, password) do
      {:ok, token} ->
        conn |> render("show.json", token: token)
      _ ->
        {:error, :unauthorized}
    end
  end
end