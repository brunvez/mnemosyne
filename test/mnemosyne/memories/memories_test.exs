defmodule Mnemosyne.MemoriesTest do
  use Mnemosyne.DataCase

  alias Mnemosyne.Memories
  alias Mnemosyne.MemoryFactory
  alias Mnemosyne.UserFactory

  describe "memories" do
    setup [:create_user]
    alias Mnemosyne.Memories.Memory

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def fixture(:memory, user) do
      MemoryFactory.create(user)
    end

    test "list_user_memories/1 returns all memories created by the user", %{user: user} do
      memory = fixture(:memory, user)
      assert Memories.list_user_memories(user) == [memory]
    end

    test "get_memory!/1 returns the memory with given id", %{user: user} do
      memory = fixture(:memory, user)
      assert Memories.get_memory!(memory.id) == memory
    end

    test "create_memory/2 with valid data creates a memory for the user", %{user: user} do
      assert {:ok, %Memory{} = memory} = Memories.create_memory(user, @valid_attrs)
      assert memory.description == "some description"
      assert memory.title == "some title"
    end

    test "create_memory/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Memories.create_memory(user, @invalid_attrs)
    end

    test "update_memory/2 with valid data updates the memory", %{user: user} do
      memory = fixture(:memory, user)
      assert {:ok, %Memory{} = memory} = Memories.update_memory(memory, @update_attrs)
      assert memory.description == "some updated description"
      assert memory.title == "some updated title"
    end

    test "update_memory/2 with invalid data returns error changeset", %{user: user} do
      memory = fixture(:memory, user)
      assert {:error, %Ecto.Changeset{}} = Memories.update_memory(memory, @invalid_attrs)
      assert memory == Memories.get_memory!(memory.id)
    end

    test "delete_memory/1 deletes the memory", %{user: user} do
      memory = fixture(:memory, user)
      assert {:ok, %Memory{}} = Memories.delete_memory(memory)
      assert_raise Ecto.NoResultsError, fn -> Memories.get_memory!(memory.id) end
    end

    test "change_memory/1 returns a memory changeset", %{user: user} do
      memory = fixture(:memory, user)
      assert %Ecto.Changeset{} = Memories.change_memory(memory)
    end

    defp create_user(_) do
      user = UserFactory.create(:user)
      {:ok, user: user}
    end
  end
end
