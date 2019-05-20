defmodule Mnemosyne.Memories.Memory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mnemosyne.Accounts.User
  alias Mnemosyne.Memories.Tag

  schema "memories" do
    field :description, :string
    field :title, :string
    belongs_to :user, User

    many_to_many :tags, Tag,
      join_through: "memories_tags",
      on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(memory, attrs) do
    memory
    |> cast(attrs, [:title, :description, :user_id])
    |> validate_required([:title, :user_id])
    |> assoc_constraint(:user)
  end
end
