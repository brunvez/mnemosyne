defmodule InfkeeperWeb.Authentication.SetCurrentUser do
  def init(opts), do: opts

  def call(conn, _opts) do
    current_token = Guardian.Plug.current_token(conn)

     case Infkeeper.Authentication.get_user_by_token(current_token) do
      {:ok, user, _claims} ->
        Plug.Conn.assign(conn, :current_user, user)
      {:error, _reason} ->
        Plug.Conn.send_resp(conn, :not_found, "")
    end
  end
end