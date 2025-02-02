defmodule MnemosyneWeb.Api.V1.MemoryView do
  use MnemosyneWeb, :view
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
      tags: Enum.map(memory.tags, & &1.name)
    }
  end
end
