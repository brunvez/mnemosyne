defmodule Mnemosyne.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :title, :string, null: false
      add :relative_position, :integer, null: false
      add :memory_id, references(:memories, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:links, [:memory_id])
  end
end
