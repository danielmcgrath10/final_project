defmodule FinalProject.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :value, :integer, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :review_id, references(:reviews, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:votes, [:review_id, :user_id], unique: true)
    create index(:votes, [:user_id])
    create index(:votes, [:review_id])
  end
end
