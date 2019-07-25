defmodule MnemosyneWeb.MemoryView do
  use MnemosyneWeb, :view

  defp parse_description(nil), do: ""
  defp parse_description(description) do
    case Earmark.as_html(description) do
      {:ok, html, _} -> html
      _ -> gettext("Couldn't parse description")
    end
  end

  defp enumerate_tags(tags) do
    tags
    |> Enum.map(& &1.name)
    |> Enum.join(", ")
  end
end
