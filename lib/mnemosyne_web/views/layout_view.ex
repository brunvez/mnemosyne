defmodule MnemosyneWeb.LayoutView do
  use MnemosyneWeb, :view

  def current_user(conn) do
    Map.get(conn.assigns, :current_user)
  end
end
