defmodule Mnemosyne.AccountsTest do
  use Mnemosyne.DataCase

  alias Mnemosyne.Accounts

  describe "users" do
    alias Mnemosyne.Accounts.User

    @valid_attrs %{
      email: "some@email.com",
      password: "password",
      password_confirmation: "password"
    }
    @invalid_attrs %{
      email: "some@email.com",
      password: "password",
      password_confirmation: "NOTpassword"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id).email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end
end
