defmodule FinalProject.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :photo_hash, :string, default: FinalProject.Inject.photo("user.png")

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_hash, :photo_hash])
    |> add_password_hash(attrs["password"])
    |> validate_required([:name, :email, :password_hash, :photo_hash])
  end

  def add_password_hash(cset, nil) do
    cset
  end

  def add_password_hash(cset, password) do
    IO.inspect cset
    IO.inspect password
    change(cset, Argon2.add_hash(password))
  end
end
