defmodule MnemosyneWeb.MemoryController do
  use MnemosyneWeb, :controller

  alias Mnemosyne.Memories
  alias Mnemosyne.Memories.Memory

  def index(conn, _params) do
    memories = Memories.list_memories(current_user(conn))
    render(conn, "index.html", memories: memories)
  end

  def new(conn, _params) do
    changeset = Memories.change_memory(%Memory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"memory" => memory_params}) do
    tags = parse_tags(memory_params["tags"])

    case Memories.create_memory(current_user(conn), Map.put(memory_params, "tags", tags)) do
      {:ok, memory} ->
        conn
        |> put_flash(:info, "Memory created successfully.")
        |> redirect(to: Routes.memory_path(conn, :show, memory))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    memory = Memories.get_memory!(id)
    render(conn, "show.html", memory: memory)
  end

  def edit(conn, %{"id" => id}) do
    memory = Memories.get_memory!(id)
    changeset = Memories.change_memory(memory)
    render(conn, "edit.html", memory: memory, changeset: changeset)
  end

  def update(conn, %{"id" => id, "memory" => memory_params}) do
    memory = Memories.get_memory!(id)
    tags = parse_tags(memory_params["tags"])

    case Memories.update_memory(memory, Map.put(memory_params, "tags", tags)) do
      {:ok, memory} ->
        conn
        |> put_flash(:info, "Memory updated successfully.")
        |> redirect(to: Routes.memory_path(conn, :show, memory))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", memory: memory, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    memory = Memories.get_memory!(id)
    {:ok, _memory} = Memories.delete_memory(memory)

    conn
    |> put_flash(:info, "Memory deleted successfully.")
    |> redirect(to: Routes.root_path(conn, :index))
  end

  defp parse_tags(tags_string) do
    (tags_string || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.downcase/1)
    |> Enum.reject(&(&1 == ""))
  end
end
