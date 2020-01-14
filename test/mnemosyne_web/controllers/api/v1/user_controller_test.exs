defmodule MnemosyneWeb.Api.V1.UserControllerTest do
  use MnemosyneWeb.ConnCase, async: true

  alias Mnemosyne.Accounts

  @create_attrs %{
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
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_user_path(conn, :create), user: @create_attrs)

      assert %{
               "id" => id,
               "email" => "some@email.com"
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
