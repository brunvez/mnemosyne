defmodule MnemosyneWeb.MemoryController do
  use MnemosyneWeb, :controller

  alias Mnemosyne.Memories
  alias Mnemosyne.Memories.Memory
  alias Mnemosyne.Memories.MemoryPolicy

  plug :load_memory when action in [:show, :edit, :update, :delete]
  plug :check_if_authorized, :view when action == :show
  plug :check_if_authorized, :edit when action in [:edit, :update]
  plug :check_if_authorized, :delete when action == :delete

  def index(conn, _params) do
    memories = Memories.list_user_memories(current_user(conn))
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
        |> put_flash(:info, gettext("Memory created successfully"))
        |> redirect(to: Routes.memory_path(conn, :show, memory))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    memory = conn.assigns.memory
    render(conn, "show.html", memory: memory)
  end

  def edit(conn, _params) do
    memory = conn.assigns.memory
    changeset = Memories.change_memory(memory)
    render(conn, "edit.html", memory: memory, changeset: changeset)
  end

  def update(conn, %{"memory" => memory_params}) do
    memory = conn.assigns.memory
    tags = parse_tags(memory_params["tags"])

    case Memories.update_memory(memory, Map.put(memory_params, "tags", tags)) do
      {:ok, memory} ->
        conn
        |> put_flash(:info, gettext("Memory updated successfully"))
        |> redirect(to: Routes.memory_path(conn, :show, memory))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", memory: memory, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    memory = conn.assigns.memory
    {:ok, _memory} = Memories.delete_memory(memory)

    conn
    |> put_flash(:info, gettext("Memory deleted successfully"))
    |> redirect(to: Routes.root_path(conn, :index))
  end

  defp parse_tags(tags_string) do
    (tags_string || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.downcase/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp load_memory(%Plug.Conn{params: %{"id" => id}} = conn, _options) do
    memory = Memories.get_memory!(id)
    assign(conn, :memory, memory)
  end

  defp check_if_authorized(conn, permission) do
    memory = conn.assigns.memory
    user = current_user(conn)

    case check_permissions(permission, memory, user) do
      :ok ->
        conn

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, gettext("You are not authorized to access that memory"))
        |> redirect(to: Routes.root_path(conn, :index))
        |> halt()
    end
  end

  defp check_permissions(:view, memory, user),
    do: MemoryPolicy.can_view?(memory, user)

  defp check_permissions(:edit, memory, user),
    do: MemoryPolicy.can_edit?(memory, user)

  defp check_permissions(:delete, memory, user),
    do: MemoryPolicy.can_delete?(memory, user)
end
