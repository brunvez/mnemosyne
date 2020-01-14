defmodule MnemosyneWeb.Api.V1.MemoryView do
  use MnemosyneWeb, :view
  alias MnemosyneWeb.Api.V1.FragmentView
  alias MnemosyneWeb.Api.V1.MemoryView

  def render("show.json", %{memory: memory, memory_url: memory_url}) do
    %{
      data: render_one(memory, MemoryView, "memory.json"),
      memory_url: memory_url
    }
  end

  def render("show.json", %{memory: memory}) do
    %{data: render_one(memory, MemoryView, "memory.json")}
  end

  def render("memory.json", %{memory: memory}) do
    %{
      id: memory.id,
      title: memory.title,
      description: memory.description,
      fragments: render_fragments(memory.fragments),
      tags: Enum.map(memory.tags, & &1.name)
    }
  end

  defp render_fragments(fragments) do
    render_many(fragments, FragmentView, "fragment.json")
  end
end
