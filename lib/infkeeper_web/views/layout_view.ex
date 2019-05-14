defmodule InfkeeperWeb.LayoutView do
  use InfkeeperWeb, :view

  def current_user(conn) do
    Map.get(conn.assigns, :current_user)
  end
end
