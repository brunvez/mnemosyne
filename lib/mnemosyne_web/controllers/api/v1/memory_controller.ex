defmodule MnemosyneWeb.Api.V1.MemoryController do
  use MnemosyneWeb, :controller

  alias Mnemosyne.Fragments
  alias Mnemosyne.Memories
  alias Mnemosyne.Memories.MemoryPolicy

  action_fallback MnemosyneWeb.FallbackController

  plug :load_memory when action in [:show, :update]
  plug :check_if_authorized, :view when action == :show
  plug :check_if_authorized, :edit when action == :update
  plug :check_if_authorized, :delete when action == :delete

  def show(conn, _params) do
    memory = conn.assigns.memory
    render(conn, "show.json", memory: memory)
  end

  def create(conn, %{"memory" => memory_params}) do
    case Memories.create_memory(current_user(conn), memory_params) do
      {:ok, memory} ->
        memory = Fragments.preload_memory_fragments(memory)

        conn
        |> put_status(:created)
        |> render(
          "show.json",
          memory: memory,
          memory_url: Routes.memory_url(conn, :show, memory)
        )

      error ->
        error
    end
  end

  def update(conn, %{"memory" => memory_params}) do
    memory = conn.assigns.memory

    case Memories.update_memory(memory, memory_params) do
      {:ok, memory} ->
        conn
        |> render(
          "show.json",
          memory: memory,
          memory_url: Routes.memory_url(conn, :show, memory)
        )

      error ->
        error
    end
  end

  defp load_memory(%Plug.Conn{params: %{"id" => id}} = conn, _options) do
    memory =
      id
      |> Memories.get_memory!()
      |> Fragments.preload_memory_fragments()

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
        |> put_status(:unauthorized)
        |> json(%{errors: gettext("You are not authorized to access that memory")})
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
