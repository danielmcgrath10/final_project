defmodule FinalProject.PostsTest do
  use FinalProject.DataCase

  alias FinalProject.Posts

  describe "posts" do
    alias FinalProject.Posts.Post

    @valid_attrs %{caption: "some caption", drinkName: "some drinkName", lat: 120.5, lon: 120.5, name: "some name", photo_hash: "some photo_hash", rating: 120.5, timestamp: "2010-04-17T14:00:00Z"}
    @update_attrs %{caption: "some updated caption", drinkName: "some updated drinkName", lat: 456.7, lon: 456.7, name: "some updated name", photo_hash: "some updated photo_hash", rating: 456.7, timestamp: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{caption: nil, drinkName: nil, lat: nil, lon: nil, name: nil, photo_hash: nil, rating: nil, timestamp: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert post.caption == "some caption"
      assert post.drinkName == "some drinkName"
      assert post.lat == 120.5
      assert post.lon == 120.5
      assert post.name == "some name"
      assert post.photo_hash == "some photo_hash"
      assert post.rating == 120.5
      assert post.timestamp == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Posts.update_post(post, @update_attrs)
      assert post.caption == "some updated caption"
      assert post.drinkName == "some updated drinkName"
      assert post.lat == 456.7
      assert post.lon == 456.7
      assert post.name == "some updated name"
      assert post.photo_hash == "some updated photo_hash"
      assert post.rating == 456.7
      assert post.timestamp == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
