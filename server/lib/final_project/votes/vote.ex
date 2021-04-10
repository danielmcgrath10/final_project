defmodule FinalProject.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :value, :integer

    belongs_to :user, FinalProject.Users.User
    belongs_to :review, FinalProject.Reviews.Review

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:value, :user_id, :review_id])
    |> validate_required([:value, :user_id, :review_id])
  end
end
