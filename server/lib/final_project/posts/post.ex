defmodule FinalProject.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :caption, :string
    field :drinkName, :string
    field :location, :string
    # field :photo_hash, :string
    field :rating, :float
    field :timestamp, :utc_datetime

    belongs_to :user, FinalProject.Users.User

    has_many :comments, FinalProject.Comments.Comment
    has_many :likes, FinalProject.Likes.Like

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    # Remember to add photo_hash back when add photos
    post
    |> cast(attrs, [:location, :drinkName, :rating, :caption, :timestamp, :user_id])
    |> validate_required([:location, :drinkName, :rating, :caption, :timestamp, :user_id])
  end
end
