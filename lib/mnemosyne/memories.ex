defmodule Mnemosyne.Memories do
  @moduledoc """
  Creates, updates and retrieves
  memories associated with a given user
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Mnemosyne.Repo

  alias Mnemosyne.Accounts.User
  alias Mnemosyne.Memories.Memory
  alias Mnemosyne.Memories.Tag

  @fragments_creator Mnemosyne.Fragments

  def list_user_memories(%User{id: user_id}) do
    Memory
    |> where(user_id: ^user_id)
    |> Repo.all()
    |> Repo.preload(:tags)
  end

  def get_memory!(id) do
    Memory
    |> Repo.get!(id)
    |> Repo.preload(:tags)
  end

  def create_memory(user, attrs \\ %{}) do
    tag_names = extract_option(:tags, attrs, default: [])
    fragments_attrs = extract_option(:fragments, attrs, default: [])

    Multi.new()
    |> Multi.run(:tags, fn _, _ -> {:ok, get_or_insert_tags(tag_names)} end)
    |> Multi.insert(:memory, &build_memory(user, &1.tags, attrs))
    |> Multi.run(:fragments, fn _, %{memory: memory} ->
      @fragments_creator.create_memory_fragments(memory, fragments_attrs)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{memory: memory}} -> {:ok, memory}
      {:error, :memory, value, _} -> {:error, value}
      {:error, :fragments, [error | _], _} -> {:error, error}
    end
  end

  def update_memory(%Memory{} = memory, attrs) do
    tag_names = extract_option(:tags, attrs, default: [])

    Multi.new()
    |> Multi.run(:tags, fn _, _ -> {:ok, get_or_insert_tags(tag_names)} end)
    |> Multi.update(:memory, &build_memory(memory, &1.tags, attrs))
    |> Repo.transaction()
    |> case do
      {:ok, %{memory: memory}} -> {:ok, memory}
      {:error, :memory, value, _} -> {:error, value}
    end
  end

  def delete_memory(%Memory{} = memory) do
    Repo.delete(memory)
  end

  def change_memory(%Memory{} = memory), do: Memory.changeset(memory, %{})

  defp extract_option(key, map, default: default) when is_atom(key) do
    map[key] || map[Atom.to_string(key)] || default
  end

  # TODO use upsert after postgres upgrade
  defp get_or_insert_tags(tag_names) do
    Enum.map(tag_names, &get_or_insert_tag/1)
  end

  defp get_or_insert_tag(name) do
    Repo.get_by(Tag, name: name) || maybe_insert_tag(name)
end

  defp maybe_insert_tag(name) do
    %Tag{}
    |> Tag.changeset(%{name: name})
    |> Repo.insert()
    |> case do
      {:ok, tag} -> tag
      {:error, _} -> Repo.get_by!(Tag, name: name)
    end
  end

  defp build_memory(%Memory{} = memory, tags, attrs) do
    memory
    |> Memory.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
  end

  defp build_memory(user, tags, attrs) do
    %Memory{user_id: user.id}
    |> Memory.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, tags)
  end
end
