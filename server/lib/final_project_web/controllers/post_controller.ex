defmodule FinalProjectWeb.PostController do
  use FinalProjectWeb, :controller

  alias FinalProject.Posts
  alias FinalProject.Posts.Post
  alias FinalProjectWeb.SessionController

  action_fallback FinalProjectWeb.FallbackController

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params, "session" => session}) do
    IO.inspect post_params
    IO.inspect session
    if SessionController.authorized?(conn, session["user_id"], session["token"]) do
      post_params = post_params
      |> Map.put("user_id", session["user_id"])
      |> Map.put("timestamp", DateTime.utc_now())

      with {:ok, %Post{} = post} <- Posts.create_post(post_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.post_path(conn, :show, post))
        |> render("show.json", post: post)
      end
    else
      conn
      |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(%{error: "Unauthorized"}))
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
