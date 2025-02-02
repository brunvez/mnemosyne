defmodule MnemosyneWeb.UserController do
  use MnemosyneWeb, :controller

  alias Mnemosyne.Accounts
  alias Mnemosyne.Accounts.User
  alias Mnemosyne.Authentication.Guardian.Plug, as: AuthenticationPlug

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Successfully signed up"))
        |> AuthenticationPlug.sign_in(user)
        |> redirect(to: Routes.root_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
