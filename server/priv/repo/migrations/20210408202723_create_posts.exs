defmodule FinalProject.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :location, :string
      add :drinkName, :string, null: false
      # add :photo_hash, :string
      add :rating, :float, null: false
      add :caption, :text
      add :timestamp, :utc_datetime, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:posts, [:user_id])
  end
end
