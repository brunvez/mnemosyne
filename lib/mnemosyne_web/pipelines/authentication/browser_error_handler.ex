defmodule MnemosyneWeb.Authentication.BrowserErrorHandler do
  @moduledoc """
  Handles errors related to authentication redirecting
  to appropiate pages
  """
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias MnemosyneWeb.Router.Helpers, as: Routes

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, :unauthenticated}, _opts) do
    conn
    |> put_flash(:error, "You must be authenticated in to access that page")
    |> redirect(to: Routes.login_path(conn, :new))
    |> halt()
  end

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, :already_authenticated}, _opts) do
    conn
    |> put_flash(:error, "You cannot be authenticated to access that page")
    |> redirect(to: Routes.root_path(conn, :index))
    |> halt()
  end
end
