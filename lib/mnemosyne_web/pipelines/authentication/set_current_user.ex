defmodule MnemosyneWeb.Authentication.SetCurrentUser do
  @moduledoc """
  Sets the current user for an authenticated request
  in the connection
  """
  def init(opts), do: opts

  def call(conn, _opts) do
    case Guardian.Plug.current_token(conn) do
      nil -> set_current_user_from_session(conn)
      token -> set_current_user_from_token(conn, token)
    end
  end

  defp set_current_user_from_session(conn) do
    user = Guardian.Plug.current_resource(conn)
    Plug.Conn.assign(conn, :current_user, user)
  end

  defp set_current_user_from_token(conn, token) do
    case Mnemosyne.Authentication.get_user_by_token(token) do
      {:ok, user, _claims} ->
        Plug.Conn.assign(conn, :current_user, user)

      {:error, _reason} ->
        Plug.Conn.send_resp(conn, :not_found, "")
    end
  end
end
