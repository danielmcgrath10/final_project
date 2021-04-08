defmodule FinalProject.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :caption, :string
    field :drinkName, :string
    field :lat, :float
    field :lon, :float
    field :name, :string
    field :photo_hash, :string
    field :rating, :float
    field :timestamp, :utc_datetime

    belongs_to :user, FinalProject.Users.User

    has_many :comments, FinalProject.Comments.Comment
    has_many :likes, FinalProject.Likes.Like

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:name, :lat, :lon, :drinkName, :photo_hash, :rating, :caption, :timestamp, :user_id])
    |> validate_required([:name, :lat, :lon, :drinkName, :photo_hash, :rating, :caption, :timestamp, :user_id])
  end
end
