defmodule Mnemosyne.MemoriesTest do
  use Mnemosyne.DataCase

  alias Mnemosyne.Memories

  describe "memories" do
    alias Mnemosyne.Memories.Memory

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def memory_fixture(attrs \\ %{}) do
      {:ok, memory} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Memories.create_memory()

      memory
    end

    test "list_memories/0 returns all memories" do
      memory = memory_fixture()
      assert Memories.list_memories() == [memory]
    end

    test "get_memory!/1 returns the memory with given id" do
      memory = memory_fixture()
      assert Memories.get_memory!(memory.id) == memory
    end

    test "create_memory/1 with valid data creates a memory" do
      assert {:ok, %Memory{} = memory} = Memories.create_memory(@valid_attrs)
      assert memory.description == "some description"
      assert memory.title == "some title"
    end

    test "create_memory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Memories.create_memory(@invalid_attrs)
    end

    test "update_memory/2 with valid data updates the memory" do
      memory = memory_fixture()
      assert {:ok, %Memory{} = memory} = Memories.update_memory(memory, @update_attrs)
      assert memory.description == "some updated description"
      assert memory.title == "some updated title"
    end

    test "update_memory/2 with invalid data returns error changeset" do
      memory = memory_fixture()
      assert {:error, %Ecto.Changeset{}} = Memories.update_memory(memory, @invalid_attrs)
      assert memory == Memories.get_memory!(memory.id)
    end

    test "delete_memory/1 deletes the memory" do
      memory = memory_fixture()
      assert {:ok, %Memory{}} = Memories.delete_memory(memory)
      assert_raise Ecto.NoResultsError, fn -> Memories.get_memory!(memory.id) end
    end

    test "change_memory/1 returns a memory changeset" do
      memory = memory_fixture()
      assert %Ecto.Changeset{} = Memories.change_memory(memory)
    end
  end
end
