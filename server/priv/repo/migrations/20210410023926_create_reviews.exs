defmodule FinalProject.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :place_id, :string, null: false
      add :rating, :float

      timestamps()
    end

  end
end
