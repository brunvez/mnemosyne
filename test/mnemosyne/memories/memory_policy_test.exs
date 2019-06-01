defmodule Mnemosyne.MemoryPolicyTest do
  use ExUnit.Case, async: true

  alias Mnemosyne.Accounts.User
  alias Mnemosyne.Memories.Memory
  alias Mnemosyne.Memories.MemoryPolicy

  describe "can_view?/2" do
    test "when the memory belongs to the user returns :ok" do
      assert :ok == MemoryPolicy.can_view?(%Memory{user_id: 5}, %User{id: 5})
    end

    test "when the memory belongs to the user returns unauthorized" do
      assert {:error, :unauthorized} == MemoryPolicy.can_view?(%Memory{user_id: 1}, %User{id: 5})
    end
  end

  describe "can_edit?/2" do
    test "when the memory belongs to the user returns :ok" do
      assert :ok == MemoryPolicy.can_edit?(%Memory{user_id: 5}, %User{id: 5})
    end

    test "when the memory belongs to the user returns unauthorized" do
      assert {:error, :unauthorized} == MemoryPolicy.can_edit?(%Memory{user_id: 1}, %User{id: 5})
    end
  end

  describe "can_delete?/2" do
    test "when the memory belongs to the user returns :ok" do
      assert :ok == MemoryPolicy.can_delete?(%Memory{user_id: 5}, %User{id: 5})
    end

    test "when the memory belongs to the user returns unauthorized" do
      assert {:error, :unauthorized} ==
               MemoryPolicy.can_delete?(%Memory{user_id: 1}, %User{id: 5})
    end
  end
end
