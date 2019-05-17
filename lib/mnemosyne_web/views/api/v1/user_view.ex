defmodule MnemosyneWeb.Api.V1.UserView do
  use MnemosyneWeb, :view
  alias MnemosyneWeb.Api.V1.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end
end
