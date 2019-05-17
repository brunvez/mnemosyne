defmodule MnemosyneWeb.SessionControllerTest do
  use MnemosyneWeb.ConnCase

  alias Mnemosyne.UserFactory

  @password "password"
  @create_attrs %{email: "some@email.com", password: @password}
  @invalid_attrs %{email: "some@email.com", password: "NOTpassword"}

  describe "login" do
    test "renders a login form", %{conn: conn} do
      conn = get(conn, Routes.login_path(conn, :new))
      assert html_response(conn, 200) =~ "Log in"
    end
  end

  describe "create session when not logged in" do
    setup [:create_user]

    test "redirects to root when the data is valid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), login: @create_attrs)

      assert redirected_to(conn) == Routes.root_path(conn, :index)
    end

    test "loggs the user in when the data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.session_path(conn, :create), login: @create_attrs)

      assert Guardian.Plug.current_resource(conn).id == user.id
    end

    test "redirects back to login with errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), login: @invalid_attrs)

      assert redirected_to(conn) == Routes.login_path(conn, :new)
      assert %{"error" => "Invalid email or password"} = get_flash(conn)
    end
  end

  @tag :browser_authenticated
  describe "create session when logged in" do
    test "redirects to root with an error message", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), login: @create_attrs)

      assert redirected_to(conn) == Routes.root_path(conn, :index)
      assert %{"error" => "You cannot be authenticated to access that page"} = get_flash(conn)
    end
  end

  @tag :browser_authenticated
  describe "delete session when logged in" do
    test "redirects to the login page with a message", %{conn: conn} do
      conn = delete(conn, Routes.session_path(conn, :delete))

      assert redirected_to(conn) == Routes.login_path(conn, :new)
      assert %{"info" => "Successfully logged out"} = get_flash(conn)
    end

    test "logs the user out of the session when logged in", %{conn: conn} do
      conn = delete(conn, Routes.session_path(conn, :delete))

      assert nil == Guardian.Plug.current_resource(conn)
    end
  end

  describe "delete session when not logged in" do
    test "redirects the user to the login page with an error", %{conn: conn} do
      conn = delete(conn, Routes.session_path(conn, :delete))

      assert redirected_to(conn) == Routes.login_path(conn, :new)
      assert %{"error" => "You must be authenticated in to access that page"} = get_flash(conn)
    end
  end

  defp create_user(_) do
    attrs = Map.put(@create_attrs, :password_confirmation, @password)
    user = UserFactory.create(:user, attrs)
    {:ok, user: user}
  end
end
