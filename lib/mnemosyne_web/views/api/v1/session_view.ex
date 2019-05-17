defmodule MnemosyneWeb.Api.V1.SessionView do
  use MnemosyneWeb, :view

  def render("show.json", %{token: token}) do
    %{data: %{token: token}}
  end
end
