defmodule Mnemosyne.Repo.Migrations.CreateMemoryTag do
  use Ecto.Migration

  def change do
    create table(:memories_tags) do
      add :memory_id, references(:memories, on_delete: :delete_all), null: false
      add :tag_id, references(:tags, on_delete: :delete_all), null: false
    end

    create index(:memories_tags, [:memory_id])
    create index(:memories_tags, [:tag_id])
    create unique_index(:memories_tags, [:memory_id, :tag_id])
  end
end
