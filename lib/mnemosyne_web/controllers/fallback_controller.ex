defmodule MnemosyneWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use MnemosyneWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(MnemosyneWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(MnemosyneWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized, message}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{errors: message})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{errors: "Invalid email or password"})
  end
end
