defmodule FinalProject.RevComments do
  @moduledoc """
  The RevComments context.
  """

  import Ecto.Query, warn: false
  alias FinalProject.Repo

  alias FinalProject.RevComments.RevComment

  @doc """
  Returns the list of revcomment.

  ## Examples

      iex> list_revcomment()
      [%RevComment{}, ...]

  """
  def list_revcomment do
    Repo.all(RevComment)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single rev_comment.

  Raises `Ecto.NoResultsError` if the Rev comment does not exist.

  ## Examples

      iex> get_rev_comment!(123)
      %RevComment{}

      iex> get_rev_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rev_comment!(id) do
    Repo.get!(RevComment, id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a rev_comment.

  ## Examples

      iex> create_rev_comment(%{field: value})
      {:ok, %RevComment{}}

      iex> create_rev_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rev_comment(attrs \\ %{}) do
    %RevComment{}
    |> RevComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rev_comment.

  ## Examples

      iex> update_rev_comment(rev_comment, %{field: new_value})
      {:ok, %RevComment{}}

      iex> update_rev_comment(rev_comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rev_comment(%RevComment{} = rev_comment, attrs) do
    rev_comment
    |> RevComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rev_comment.

  ## Examples

      iex> delete_rev_comment(rev_comment)
      {:ok, %RevComment{}}

      iex> delete_rev_comment(rev_comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rev_comment(%RevComment{} = rev_comment) do
    Repo.delete(rev_comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rev_comment changes.

  ## Examples

      iex> change_rev_comment(rev_comment)
      %Ecto.Changeset{data: %RevComment{}}

  """
  def change_rev_comment(%RevComment{} = rev_comment, attrs \\ %{}) do
    RevComment.changeset(rev_comment, attrs)
  end
end
