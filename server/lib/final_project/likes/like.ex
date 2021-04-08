defmodule FinalProject.Likes.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    field :value, :integer

    belongs_to :user, FinalProject.Users.User
    belongs_to :post, FinalProject.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:value, :user_id, :post_id])
    |> validate_required([:value, :user_id, :post_id])
  end
end
