defmodule Mnemosyne.Memories do
  @moduledoc """
  The Memories context.
  """

  import Ecto.Query, warn: false
  alias Mnemosyne.Repo

  alias Mnemosyne.Memories.Memory

  def list_memories(user) do
    Memory
    |> where(user_id: ^user.id)
    |> Repo.all()
  end

  def get_memory!(id), do: Repo.get!(Memory, id)

  def create_memory(user, attrs \\ %{}) do
    %Memory{user_id: user.id}
    |> Memory.changeset(attrs)
    |> Repo.insert()
  end

  def update_memory(%Memory{} = memory, attrs) do
    memory
    |> Memory.changeset(attrs)
    |> Repo.update()
  end

  def delete_memory(%Memory{} = memory) do
    Repo.delete(memory)
  end

  def change_memory(%Memory{} = memory) do
    Memory.changeset(memory, %{})
  end

  defp tags_from_string(tags_string) do
    tags_string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
  end
end
