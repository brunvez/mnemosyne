defmodule Mnemosyne.FragmentsTest do
  use Mnemosyne.DataCase

  alias Mnemosyne.Fragments
  alias Mnemosyne.MemoryFactory

  describe "links" do
    alias Mnemosyne.Fragments.Link

    @valid_attrs %{title: "some title", url: "some url", relative_position: 1}
    @update_attrs %{title: "some updated title", url: "some updated url", relative_position: 2}
    @invalid_attrs %{title: nil, url: nil}

    def fixture(schema, attrs \\ %{})

    def fixture(:link, attrs) do
      memory = fixture(:memory)
      {:ok, link} =
        attrs
        |> Map.put(:memory_id, memory.id)
        |> Enum.into(@valid_attrs)
        |> Fragments.create_link()

      link
    end

    def fixture(:memory, attrs) do
      MemoryFactory.create_with_user(attrs)
    end

    test "list_links/0 returns all links" do
      link = fixture(:link)
      assert Fragments.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = fixture(:link)
      assert Fragments.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      memory = fixture(:memory)
      attrs = Map.put(@valid_attrs, :memory_id, memory.id)
      assert {:ok, %Link{} = link} = Fragments.create_link(attrs)
      assert link.title == "some title"
      assert link.url == "some url"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fragments.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = fixture(:link)
      assert {:ok, %Link{} = link} = Fragments.update_link(link, @update_attrs)
      assert link.title == "some updated title"
      assert link.url == "some updated url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = fixture(:link)
      assert {:error, %Ecto.Changeset{}} = Fragments.update_link(link, @invalid_attrs)
      assert link == Fragments.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = fixture(:link)
      assert {:ok, %Link{}} = Fragments.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Fragments.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = fixture(:link)
      assert %Ecto.Changeset{} = Fragments.change_link(link)
    end
  end
end
