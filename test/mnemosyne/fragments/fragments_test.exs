defmodule Mnemosyne.FragmentsTest do
  use Mnemosyne.DataCase, async: true

  alias Mnemosyne.Fragments
  alias Mnemosyne.Fragments.Link
  alias Mnemosyne.MemoryFactory

  @valid_link_attrs %{title: "some title", url: "some url", relative_position: 1}
  @update_link_attrs %{title: "some updated title", url: "some updated url", relative_position: 2}
  @invalid_link_attrs %{title: nil, url: nil}

  def fixture(schema, attrs \\ %{})

  def fixture(:link, attrs) do
    memory = fixture(:memory)
    attrs = Enum.into(attrs, @valid_link_attrs)
    {:ok, link} = Fragments.create_link(memory, attrs)

    link
  end

  def fixture(:memory, attrs) do
    MemoryFactory.create_with_user(attrs)
  end

  describe "fragments" do
    setup [:create_memory]

    @valid_attrs %{type: Link.fragment_type(), attributes: @valid_link_attrs}
    @invalid_attrs %{type: Link.fragment_type(), attributes: @invalid_link_attrs}

    test "create_memory_fragments/2 with valid fragments", %{memory: memory} do
      assert {:ok,
              [
                %Link{
                  title: "some title",
                  url: "some url",
                  relative_position: 0
                }
              ]} = Fragments.create_memory_fragments(memory, [@valid_attrs])
    end

    test "create_memory_fragments/2 with invalid fragments", %{memory: memory} do
      assert {:error,
              [
                %Ecto.Changeset{
                  valid?: false
                }
              ]} = Fragments.create_memory_fragments(memory, [@valid_attrs, @invalid_attrs])
    end

    defp create_memory(_context) do
      memory = fixture(:memory)
      {:ok, memory: memory}
    end
  end

  describe "links" do
    alias Mnemosyne.Fragments.Link

    test "list_memory_links/1 returns all links for the memory" do
      link = fixture(:link)
      link_id = link.id

      assert [%Link{id: ^link_id}] = Fragments.list_memory_links(link.memory)
    end

    test "create_link/1 with valid data creates a link" do
      memory = fixture(:memory)
      assert {:ok, %Link{} = link} = Fragments.create_link(memory, @valid_link_attrs)
      assert link.title == "some title"
      assert link.url == "some url"
    end

    test "create_link/1 with invalid data returns error changeset" do
      memory = fixture(:memory)
      assert {:error, %Ecto.Changeset{}} = Fragments.create_link(memory, @invalid_link_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = fixture(:link)
      assert {:ok, %Link{} = link} = Fragments.update_link(link, @update_link_attrs)
      assert link.title == "some updated title"
      assert link.url == "some updated url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = fixture(:link)
      assert {:error, %Ecto.Changeset{}} = Fragments.update_link(link, @invalid_link_attrs)
    end

    test "delete_link/1 deletes the link" do
      link = fixture(:link)
      assert {:ok, %Link{}} = Fragments.delete_link(link)
      assert [] == Fragments.list_memory_links(link.memory)
    end

    test "change_link/1 returns a link changeset" do
      link = fixture(:link)
      assert %Ecto.Changeset{} = Fragments.change_link(link)
    end
  end
end
