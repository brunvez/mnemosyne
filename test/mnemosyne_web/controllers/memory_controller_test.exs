defmodule MnemosyneWeb.MemoryControllerTest do
  use MnemosyneWeb.ConnCase
  @moduletag :browser_authenticated

  alias Mnemosyne.MemoryFactory
  alias Mnemosyne.UserFactory

  @create_attrs %{description: "some description", title: "some title", tags: "test, tags, 1 2 3"}
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    tags: "other, tags"
  }
  @invalid_attrs %{description: nil, title: nil}

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

  describe "new memory" do
    test "renders the form", %{conn: conn} do
      conn = get(conn, Routes.memory_path(conn, :new))
      assert html_response(conn, 200) =~ "New Memory"
    end
  end

  describe "create memory" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.memory_path(conn, :create), memory: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.memory_path(conn, :show, id)

      conn = get(conn, Routes.memory_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Memory"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.memory_path(conn, :create), memory: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Memory"
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

  describe "edit memory" do
    setup [:create_memory]

    test "renders the form for editing the chosen memory", %{conn: conn, memory: memory} do
      conn = get(conn, Routes.memory_path(conn, :edit, memory))
      assert html_response(conn, 200) =~ "Edit Memory"
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

  describe "update memory" do
    setup [:create_memory]

    test "redirects when data is valid", %{conn: conn, memory: memory} do
      conn = put(conn, Routes.memory_path(conn, :update, memory), memory: @update_attrs)
      assert redirected_to(conn) == Routes.memory_path(conn, :show, memory)

      conn = get(conn, Routes.memory_path(conn, :show, memory))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, memory: memory} do
      conn = put(conn, Routes.memory_path(conn, :update, memory), memory: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Memory"
    end
  end

  describe "update memory when the memory belongs to another user" do
    test "redirects with an error", %{conn: conn} do
      other_user = fixture(:user, %{email: "other@email.com"})
      memory = fixture(:memory, other_user)

      conn = put(conn, Routes.memory_path(conn, :update, memory), memory: @update_attrs)

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
