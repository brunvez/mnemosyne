defmodule Mnemosyne.MemoryFactory do
  @moduledoc """
  Creates memories and tags for their use in tests
  """
  alias Mnemosyne.Memories

  @default_attributes %{
    title: "Title",
    description: "some description"
  }

  def create(:memory, user, attrs \\ %{}) do
    {:ok, memory} = Memories.create_memory(user, [], params_for(:memory, attrs))

    memory
  end

  def create(:memory, user, %{with_tags: number_of_tags} = attrs) when is_number(number_of_tags) do
    params = params_for(:memory, Map.delete(attrs, :with_tags))
    tags = tag_names(number_of_tags)
    {:ok, memory} = Memories.create_memory(user, tags, params)

    memory
  end

  def params_for(:memory, attrs \\ %{}) do
    Map.merge(
      @default_attributes,
      attrs
    )
  end

  defp tag_names(number_of_tags) do
    Enum.map((1..number_of_tags), & "tag#{&1}")
  end
end
