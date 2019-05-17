defmodule Mnemosyne.Memories.Memory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "memories" do
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(memory, attrs) do
    memory
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
