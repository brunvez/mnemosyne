defmodule InfkeeperWeb.Api.V1.UserView do
  use InfkeeperWeb, :view
  alias InfkeeperWeb.Api.V1.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end
end
