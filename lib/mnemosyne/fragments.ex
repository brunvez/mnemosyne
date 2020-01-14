defmodule Mnemosyne.Fragments do
  @moduledoc """
  Creates fragments that hold
  information for a memory
  """

  import Ecto.Query, warn: false
  alias Mnemosyne.Repo

  alias Mnemosyne.Fragments.Link
  alias Mnemosyne.Memories.Memory

  @link_fragment_type Link.fragment_type()

  def create_memory_fragments(%Memory{} = memory, fragments_attrs) do
    fragments_results =
      fragments_attrs
      |> Enum.with_index()
      |> Enum.map(fn {fragment, index} ->
        attrs = extract_attr(fragment, :attributes, default: %{})

        case extract_attr(fragment, :type, default: nil) do
          @link_fragment_type ->
            create_link(memory, put_attr(attrs, :relative_position, index))

          _ ->
            {:error, :invalid_format}
        end
      end)

    group_results(fragments_results)
  end

  def preload_memory_fragments(memory) do
    memory = Repo.preload(memory, [:links])
    fragments = memory.links |> Enum.sort_by(& &1.relative_position)
    %{memory | fragments: fragments}
  end

  def list_memory_links(%Memory{id: memory_id}) do
    Link
    |> where(memory_id: ^memory_id)
    |> Repo.all()
    |> Enum.sort_by(& &1.relative_position)
  end

  def create_link(%Memory{} = memory, attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:memory, memory)
    |> Repo.insert()
  end

  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  def change_link(%Link{} = link) do
    Link.changeset(link, %{})
  end

  defp extract_attr(attrs, key, default: default) when is_atom(key) do
    attrs[key] || attrs[Atom.to_string(key)] || default
  end

  # defp put_attr(%{} = attrs, key, value), do: Map.put(attrs, key, value)

  defp put_attr(attrs, key, value) when is_atom(key) do
    case Map.keys(attrs) do
      [key_sample | _] when is_atom(key_sample) ->
        Map.put(attrs, key, value)

      _ ->
        Map.put(attrs, Atom.to_string(key), value)
    end
  end

  defp group_results(fragments_results) do
    errors = error_results(fragments_results)

    if Enum.any?(errors) do
      {:error, errors}
    else
      {:ok, created_fragments(fragments_results)}
    end
  end

  defp error_results(fragments_results) do
    fragments_results
    |> Enum.filter(fn {status, _} -> status == :error end)
    |> Enum.map(fn {_, error} -> error end)
  end

  defp created_fragments(fragments_results) do
    fragments_results
    |> Enum.map(fn {_, fragment} -> fragment end)
  end
end
