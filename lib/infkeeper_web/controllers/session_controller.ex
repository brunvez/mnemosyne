defmodule InfkeeperWeb.SessionController do
  use InfkeeperWeb, :controller

  alias Infkeeper.Authentication
  alias Infkeeper.Authentication.Guardian.Plug, as: AuthenticationPlug

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"login" => %{"email" => email, "password" => password}}) do
    case Authentication.authenticate_user_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> AuthenticationPlug.sign_in(user)
        |> put_flash(:info, gettext("Successfully logged in"))
        |> redirect(to: Routes.root_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, gettext("Invalid email or password"))
        |> redirect(to: Routes.login_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> AuthenticationPlug.sign_out()
    |> put_flash(:info, gettext("Successfully logged out"))
    |> redirect(to: Routes.login_path(conn, :new))
  end
end
