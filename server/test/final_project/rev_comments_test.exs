defmodule FinalProject.RevCommentsTest do
  use FinalProject.DataCase

  alias FinalProject.RevComments

  describe "revcomment" do
    alias FinalProject.RevComments.RevComment

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def rev_comment_fixture(attrs \\ %{}) do
      {:ok, rev_comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RevComments.create_rev_comment()

      rev_comment
    end

    test "list_revcomment/0 returns all revcomment" do
      rev_comment = rev_comment_fixture()
      assert RevComments.list_revcomment() == [rev_comment]
    end

    test "get_rev_comment!/1 returns the rev_comment with given id" do
      rev_comment = rev_comment_fixture()
      assert RevComments.get_rev_comment!(rev_comment.id) == rev_comment
    end

    test "create_rev_comment/1 with valid data creates a rev_comment" do
      assert {:ok, %RevComment{} = rev_comment} = RevComments.create_rev_comment(@valid_attrs)
      assert rev_comment.body == "some body"
    end

    test "create_rev_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RevComments.create_rev_comment(@invalid_attrs)
    end

    test "update_rev_comment/2 with valid data updates the rev_comment" do
      rev_comment = rev_comment_fixture()
      assert {:ok, %RevComment{} = rev_comment} = RevComments.update_rev_comment(rev_comment, @update_attrs)
      assert rev_comment.body == "some updated body"
    end

    test "update_rev_comment/2 with invalid data returns error changeset" do
      rev_comment = rev_comment_fixture()
      assert {:error, %Ecto.Changeset{}} = RevComments.update_rev_comment(rev_comment, @invalid_attrs)
      assert rev_comment == RevComments.get_rev_comment!(rev_comment.id)
    end

    test "delete_rev_comment/1 deletes the rev_comment" do
      rev_comment = rev_comment_fixture()
      assert {:ok, %RevComment{}} = RevComments.delete_rev_comment(rev_comment)
      assert_raise Ecto.NoResultsError, fn -> RevComments.get_rev_comment!(rev_comment.id) end
    end

    test "change_rev_comment/1 returns a rev_comment changeset" do
      rev_comment = rev_comment_fixture()
      assert %Ecto.Changeset{} = RevComments.change_rev_comment(rev_comment)
    end
  end
end
