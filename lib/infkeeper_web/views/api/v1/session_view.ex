defmodule InfkeeperWeb.Api.V1.SessionView do
  use InfkeeperWeb, :view

  def render("show.json", %{token: token}) do
    %{data: %{token: token}}
  end
end
