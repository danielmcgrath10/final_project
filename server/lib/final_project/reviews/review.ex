defmodule FinalProject.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :place_id, :string
    field :rating, :float

    has_many :revcomments, FinalProject.RevComments.RevComment
    has_many :votes, FinalProject.Votes.Vote

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:place_id, :rating])
    |> validate_required([:place_id, :rating])
  end
end
