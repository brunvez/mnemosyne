defmodule MnemosyneWeb.MemoryControllerTest do
  use MnemosyneWeb.ConnCase
  @moduletag :browser_authenticated

  alias Mnemosyne.MemoryFactory
  alias Mnemosyne.UserFactory

  def fixture(:memory, user) do
    MemoryFactory.create(user)
  end

  def fixture(:user, attrs), do: UserFactory.create(:user, attrs)

  describe "index" do
    test "lists all memories", %{conn: conn} do
      conn = get(conn, Routes.root_path(conn, :index))
      assert html_response(conn, 200) =~ "Memories"
    end
  end

  describe "show memory" do
    setup [:create_memory]

    test "renders the memory", %{conn: conn, memory: memory} do
      conn = get(conn, Routes.memory_path(conn, :show, memory))
      assert html_response(conn, 200) =~ "Show Memory"
    end
  end

  describe "show memory when the memory belongs to another user" do
    test "redirects with an error", %{conn: conn} do
      other_user = fixture(:user, %{email: "other@email.com"})
      memory = fixture(:memory, other_user)

      conn = get(conn, Routes.memory_path(conn, :show, memory))

      assert redirected_to(conn) == Routes.root_path(conn, :index)
      assert %{"error" => "You are not authorized to access that memory"} = get_flash(conn)
    end
  end

  describe "edit memory when the memory belongs to another user" do
    test "redirects with an error", %{conn: conn} do
      other_user = fixture(:user, %{email: "other@email.com"})
      memory = fixture(:memory, other_user)

      conn = get(conn, Routes.memory_path(conn, :edit, memory))

      assert redirected_to(conn) == Routes.root_path(conn, :index)
      assert %{"error" => "You are not authorized to access that memory"} = get_flash(conn)
    end
  end

  describe "delete memory" do
    setup [:create_memory]

    test "deletes the chosen memory", %{conn: conn, memory: memory} do
      conn = delete(conn, Routes.memory_path(conn, :delete, memory))
      assert redirected_to(conn) == Routes.root_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.memory_path(conn, :show, memory))
      end
    end
  end

  describe "delete memory when the memory belongs to another user" do
    test "redirects with an error message", %{conn: conn} do
      other_user = fixture(:user, %{email: "other@email.com"})
      memory = fixture(:memory, other_user)

      conn = delete(conn, Routes.memory_path(conn, :delete, memory))

      assert redirected_to(conn) == Routes.root_path(conn, :index)
      assert %{"error" => "You are not authorized to access that memory"} = get_flash(conn)
    end
  end

  defp create_memory(%{user: user}) do
    memory = fixture(:memory, user)
    {:ok, memory: memory}
  end
end
