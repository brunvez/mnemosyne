defmodule InfkeeperWeb.UserControllerTest do
  use InfkeeperWeb.ConnCase

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

  describe "sign up" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.sign_up_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign up"
    end
  end

  describe "create user" do
    test "redirects to root when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.root_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Sign up"
    end
  end
end
