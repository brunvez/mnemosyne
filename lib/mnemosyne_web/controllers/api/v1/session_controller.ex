defmodule MnemosyneWeb.Api.V1.SessionController do
  use MnemosyneWeb, :controller

  alias Mnemosyne.Authentication

  action_fallback MnemosyneWeb.FallbackController

  def create(conn, %{"login" => %{"email" => email, "password" => password}}) do
    case Authentication.token_sign_in(email, password) do
      {:ok, token} ->
        conn |> render("show.json", token: token)

      _ ->
        {:error, :unauthorized}
    end
  end
end
