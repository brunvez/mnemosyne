defmodule Mnemosyne.MemoryFactory do
  @moduledoc """
  Creates memories and tags for their use in tests
  """
  alias Mnemosyne.Memories
  alias Mnemosyne.UserFactory

  @default_attributes %{
    title: "Title",
    description: "some description",
    tags: []
  }

  def create(user, attrs \\ %{}) do
    {:ok, memory} = Memories.create_memory(user, params_for(:memory, attrs))

    memory
  end

  def create_with_user(attrs \\ %{}) do
    user = UserFactory.create(:user)

    create(user, attrs)
  end

  def params_for(:memory, attrs \\ %{}) do
    Map.merge(
      @default_attributes,
      attrs
    )
  end
end
