defmodule Mnemosyne.Memories.MemoryPolicy do
  @moduledoc """
  Controls authorization for memories
  determining whether or not a user can
  see or update a certain memory
  """
  alias Mnemosyne.Accounts.User
  alias Mnemosyne.Memories.Memory

  def can_view?(%Memory{user_id: user_id}, %User{id: user_id}), do: :ok
  def can_view?(_memory, _user), do: {:error, :unauthorized}

  def can_edit?(%Memory{user_id: user_id}, %User{id: user_id}), do: :ok
  def can_edit?(_memory, _user), do: {:error, :unauthorized}

  def can_delete?(%Memory{user_id: user_id}, %User{id: user_id}), do: :ok
  def can_delete?(_memory, _user), do: {:error, :unauthorized}
end
