defmodule MnemosyneWeb.MemoryController do
  use MnemosyneWeb, :controller

  alias Mnemosyne.Memories
  alias Mnemosyne.Memories.MemoryPolicy

  plug :load_memory when action in [:show, :edit, :delete]
  plug :check_if_authorized, :view when action == :show
  plug :check_if_authorized, :edit when action == :edit
  plug :check_if_authorized, :delete when action == :delete

  def index(conn, _params) do
    memories = Memories.list_user_memories(current_user(conn))
    render(conn, "index.html", memories: memories)
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(conn, _params) do
    memory = conn.assigns.memory
    render(conn, "show.html", memory: memory)
  end

  def edit(conn, _params) do
    memory = conn.assigns.memory
    render(conn, "edit.html", memory: memory)
  end

  def delete(conn, _params) do
    memory = conn.assigns.memory
    {:ok, _memory} = Memories.delete_memory(memory)

    conn
    |> put_flash(:info, gettext("Memory deleted successfully"))
    |> redirect(to: Routes.root_path(conn, :index))
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
