defmodule Mnemosyne.Fragments do
  @moduledoc """
  Creates fragments that hold
  information for a memory
  """

  import Ecto.Query, warn: false
  alias Mnemosyne.Repo

  alias Mnemosyne.Fragments.Link
  alias Mnemosyne.Memories.Memory

  def list_memory_links(%Memory{id: memory_id}) do
    Link
    |> where(memory_id: ^memory_id)
    |> Repo.all()
    |> Enum.sort_by(&(&1.relative_position))
  end

  def create_link(%Memory{} = memory, attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:memory, memory)
    |> Repo.insert()
  end

  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  def change_link(%Link{} = link) do
    Link.changeset(link, %{})
  end
end
