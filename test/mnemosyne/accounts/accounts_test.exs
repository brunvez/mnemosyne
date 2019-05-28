defmodule Mnemosyne.AccountsTest do
  use Mnemosyne.DataCase

  alias Mnemosyne.Accounts
  alias Mnemosyne.UserFactory

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

    def fixture(:user) do
      UserFactory.create(:user, @valid_attrs)
    end

    test "get_user!/1 returns the user with given id" do
      user = fixture(:user)
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
