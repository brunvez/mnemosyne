defmodule Mnemosyne.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :memory_id, references(:memories, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:tags, [:name])
    create index(:tags, [:memory_id])
  end
end
