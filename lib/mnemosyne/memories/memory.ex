defmodule Mnemosyne.Memories.Memory do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Mnemosyne.Accounts.User
  alias Mnemosyne.Fragments.Link
  alias Mnemosyne.Memories.Tag

  schema "memories" do
    field :title, :string
    field :description, :string
    belongs_to :user, User

    many_to_many :tags, Tag,
      join_through: "memories_tags",
      on_replace: :delete

    field :fragments, {:array, :map}, virtual: true
    has_many :links, Link

    timestamps()
  end

  @doc false
  def changeset(memory, attrs) do
    memory
    |> cast(attrs, [:title, :description, :user_id])
    |> validate_required([:title, :user_id])
    |> unique_constraint(:title)
    |> assoc_constraint(:user)
  end
end
