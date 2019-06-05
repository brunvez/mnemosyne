defmodule Mnemosyne.Fragments.Link do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Mnemosyne.Memories.Memory

  schema "links" do
    field :title, :string
    field :url, :string
    field :relative_position, :integer
    belongs_to :memory, Memory

    timestamps()
  end

  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :title, :relative_position, :memory_id])
    |> validate_required([:url, :relative_position, :memory_id])
    |> assoc_constraint(:memory)
  end
end
