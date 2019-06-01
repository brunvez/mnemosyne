defmodule MnemosyneWeb.MemoryView do
  use MnemosyneWeb, :view

  defp enumerate_tags(tags) do
    tags
    |> Enum.map(& &1.name)
    |> Enum.join(", ")
  end

  defp stringify_tags(%Ecto.Association.NotLoaded{} = _tags), do: ""

  defp stringify_tags(tags) do
    tags
    |> Enum.map(& &1.name)
    |> Enum.join(",")
  end
end
