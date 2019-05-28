defmodule Mnemosyne.MemoryFactory do
  @moduledoc """
  Creates memories and tags for their use in tests
  """
  alias Mnemosyne.Memories

  @default_attributes %{
    title: "Title",
    description: "some description",
    tags: []
  }

  def create(:memory, user, attrs \\ %{}) do
    {:ok, memory} = Memories.create_memory(user, params_for(:memory, attrs))

    memory
  end

  def params_for(:memory, attrs \\ %{}) do
    Map.merge(
      @default_attributes,
      attrs
    )
  end
end
