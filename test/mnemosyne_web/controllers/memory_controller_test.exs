defmodule MnemosyneWeb.MemoryControllerTest do
  use MnemosyneWeb.ConnCase

  alias Mnemosyne.Memories

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  def fixture(:memory) do
    {:ok, memory} = Memories.create_memory(@create_attrs)
    memory
  end

  describe "index" do
    test "lists all memories", %{conn: conn} do
      conn = get(conn, Routes.memory_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Memories"
    end
  end

  describe "new memory" do
    test "renders form", %{conn: conn} do
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

  describe "edit memory" do
    setup [:create_memory]

    test "renders form for editing chosen memory", %{conn: conn, memory: memory} do
      conn = get(conn, Routes.memory_path(conn, :edit, memory))
      assert html_response(conn, 200) =~ "Edit Memory"
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

  describe "delete memory" do
    setup [:create_memory]

    test "deletes chosen memory", %{conn: conn, memory: memory} do
      conn = delete(conn, Routes.memory_path(conn, :delete, memory))
      assert redirected_to(conn) == Routes.memory_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.memory_path(conn, :show, memory))
      end
    end
  end

  defp create_memory(_) do
    memory = fixture(:memory)
    {:ok, memory: memory}
  end
end
