defmodule FinalProjectWeb.PostControllerTest do
  use FinalProjectWeb.ConnCase

  alias FinalProject.Posts
  alias FinalProject.Posts.Post

  @create_attrs %{
    caption: "some caption",
    drinkName: "some drinkName",
    lat: 120.5,
    lon: 120.5,
    name: "some name",
    # photo_hash: "some photo_hash",
    rating: 120.5,
    timestamp: "2010-04-17T14:00:00Z"
  }
  @update_attrs %{
    caption: "some updated caption",
    drinkName: "some updated drinkName",
    lat: 456.7,
    lon: 456.7,
    name: "some updated name",
    # photo_hash: "some updated photo_hash",
    rating: 456.7,
    timestamp: "2011-05-18T15:01:01Z"
  }
  @invalid_attrs %{caption: nil, drinkName: nil, lat: nil, lon: nil, name: nil, photo_hash: nil, rating: nil, timestamp: nil}

  def fixture(:post) do
    {:ok, post} = Posts.create_post(@create_attrs)
    post
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create post" do
    test "renders post when data is valid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => id,
               "caption" => "some caption",
               "drinkName" => "some drinkName",
               "lat" => 120.5,
               "lon" => 120.5,
               "name" => "some name",
               "photo_hash" => "some photo_hash",
               "rating" => 120.5,
               "timestamp" => "2010-04-17T14:00:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update post" do
    setup [:create_post]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => id,
               "caption" => "some updated caption",
               "drinkName" => "some updated drinkName",
               "lat" => 456.7,
               "lon" => 456.7,
               "name" => "some updated name",
               "photo_hash" => "some updated photo_hash",
               "rating" => 456.7,
               "timestamp" => "2011-05-18T15:01:01Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    %{post: post}
  end
end
