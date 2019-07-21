defmodule MnemosyneWeb.Api.V1.MemoryControllerTest do
  use MnemosyneWeb.ConnCase
  @moduletag :api_authenticated

  alias Mnemosyne.MemoryFactory
  alias Mnemosyne.UserFactory

  @create_attrs %{
    description: "some description",
    title: "some title",
    tags: ["test", "tags", "1 2 3"]
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    tags: ["other", "tags"]
  }
  @invalid_attrs %{description: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  def fixture(:memory, user) do
    MemoryFactory.create(:memory, user)
  end

  def fixture(:user, attrs), do: UserFactory.create(:user, attrs)

  describe "show memory" do
    setup [:create_memory]

    test "renders the memory", %{conn: conn, memory: memory} do
      conn = get(conn, Routes.api_v1_memory_path(conn, :show, memory))

      assert %{
               "id" => id,
               "title" => "Title",
               "description" => "some description",
               "tags" => []
             } = json_response(conn, 200)["data"]
    end
  end

  describe "show memory when the memory belongs to another user" do
    test "renders an error", %{conn: conn} do
      other_user = fixture(:user, %{email: "other@email.com"})
      memory = fixture(:memory, other_user)

      conn = get(conn, Routes.api_v1_memory_path(conn, :show, memory))

      assert %{"errors" => "You are not authorized to access that memory"} =
               json_response(conn, 401)
    end
  end

  describe "create memory" do
    test "renders the memory when is valid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_memory_path(conn, :create), memory: @create_attrs)

      assert %{
               "id" => id,
               "title" => "some title",
               "description" => "some description",
               "tags" => ["test", "tags", "1 2 3"]
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_memory_path(conn, :create), memory: @invalid_attrs)

      assert %{
               "title" => ["can't be blank"]
             } = json_response(conn, 422)["errors"]
    end
  end

  describe "update memory" do
    setup [:create_memory]

    test "renders the memory when data is valid", %{conn: conn, memory: memory} do
      conn = put(conn, Routes.api_v1_memory_path(conn, :update, memory), memory: @update_attrs)

      assert %{
               "id" => id,
               "title" => "some updated title",
               "description" => "some updated description",
               "tags" => ["other", "tags"]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, memory: memory} do
      conn = put(conn, Routes.api_v1_memory_path(conn, :update, memory), memory: @invalid_attrs)

      assert %{
               "title" => ["can't be blank"]
             } = json_response(conn, 422)["errors"]
    end
  end

  describe "update memory when the memory belongs to another user" do
    test "renders an error", %{conn: conn} do
      other_user = fixture(:user, %{email: "other@email.com"})
      memory = fixture(:memory, other_user)

      conn = put(conn, Routes.api_v1_memory_path(conn, :update, memory), memory: @update_attrs)

      assert %{"errors" => "You are not authorized to access that memory"} =
               json_response(conn, 401)
    end
  end

  defp create_memory(%{user: user}) do
    memory = fixture(:memory, user)
    {:ok, memory: memory}
  end
end
