defmodule FinalProject.RevComments.RevComment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "revcomment" do
    field :body, :string

    belongs_to :user, FinalProject.Users.User
    belongs_to :review, FinalProject.Reviews.Review

    timestamps()
  end

  @doc false
  def changeset(rev_comment, attrs) do
    rev_comment
    |> cast(attrs, [:body, :user_id, :review_id])
    |> validate_required([:body, :user_id, :review_id])
  end
end
