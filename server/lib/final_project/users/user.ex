defmodule FinalProject.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :photo_hash, :string, default: FinalProject.Inject.photo("user.png")

    has_many :posts, FinalProject.Posts.Post
    has_many :comments, FinalProject.Comments.Comment
    has_many :likes, FinalProject.Likes.Like
    has_many :revcomments, FinalProject.RevComments.RevComment
    has_many :votes, FinalProject.Votes.Vote

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_hash, :photo_hash])
    |> add_password_hash(attrs["password"])
    |> validate_required([:name, :email, :password_hash, :photo_hash])
  end

  # The two functions below were inspired by the course notes
  def add_password_hash(cset, nil) do
    cset
  end

  def add_password_hash(cset, password) do
    change(cset, Argon2.add_hash(password))
  end
end
