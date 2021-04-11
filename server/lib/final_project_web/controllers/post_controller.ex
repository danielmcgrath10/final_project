# This was inspired by the Class Notes
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
    if SessionController.authorized?(conn, session["user_id"], session["token"]) do
      post_params = post_params
      |> Map.put("user_id", session["user_id"])
      |> Map.put("timestamp", DateTime.utc_now())

      with {:ok, %Post{} = _post} <- Posts.create_post(post_params) do
        posts = Posts.get_recent_posts()
        FinalProjectWeb.Endpoint.broadcast("feed:", "feed/update", FinalProjectWeb.PostView.render("index.json", posts: posts))

        conn
        |> send_resp(:created, "Success")
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
