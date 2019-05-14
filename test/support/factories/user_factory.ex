defmodule Infkeeper.UserFactory do
  @moduledoc """
  Creates users for their use in tests
  """
  alias Infkeeper.Accounts

  @default_attributes %{
    email: "some@email.com",
    password: "password",
    password_confirmation: "password"
  }

  def create(:user, attrs \\ %{}) do
    {:ok, user} =
      params_for(:user, attrs)
      |> Accounts.create_user()

    user
  end

  def params_for(:user, attrs \\ %{}) do
    Map.merge(
      @default_attributes,
      attrs
    )
  end
end
