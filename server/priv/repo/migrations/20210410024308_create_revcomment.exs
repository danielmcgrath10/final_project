defmodule FinalProject.Repo.Migrations.CreateRevcomment do
  use Ecto.Migration

  def change do
    create table(:revcomment) do
      add :body, :text, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :review_id, references(:reviews, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:revcomment, [:user_id])
    create index(:revcomment, [:review_id])
  end
end
