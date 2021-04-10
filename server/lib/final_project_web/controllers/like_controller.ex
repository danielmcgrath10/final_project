defmodule FinalProjectWeb.LikeController do
  use FinalProjectWeb, :controller

  alias FinalProject.Likes
  alias FinalProject.Likes.Like
  alias FinalProjectWeb.SessionController

  action_fallback FinalProjectWeb.FallbackController

  def index(conn, _params) do
    likes = Likes.list_likes()
    render(conn, "index.json", likes: likes)
  end

  def create(conn, %{"like" => like_params, "session" => session}) do
    if SessionController.authorized?(conn, session["user_id"], session["token"]) do
      with {:ok, %Like{} = _like} <- Likes.create_like(like_params) do
        posts = FinalProject.Posts.get_recent_posts()
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
    like = Likes.get_like!(id)
    render(conn, "show.json", like: like)
  end

  def update(conn, %{"id" => id, "like" => like_params}) do
    like = Likes.get_like!(id)

    with {:ok, %Like{} = like} <- Likes.update_like(like, like_params) do
      render(conn, "show.json", like: like)
    end
  end

  def delete(conn, %{"id" => id, "session" => session}) do
    like = Likes.get_like!(id)
    user_id = session["user_id"]
    if SessionController.authorized?(conn, user_id, session["token"]) do
      if user_id == like.user_id do
        with {:ok, %Like{}} <- Likes.delete_like(like) do
          posts = FinalProject.Posts.get_recent_posts()
          FinalProjectWeb.Endpoint.broadcast("feed:", "feed/update", FinalProjectWeb.PostView.render("index.json", posts: posts))
          send_resp(conn, :no_content, "")
        end
      else
        conn
        |> put_resp_header(
          "content-type",
          "application/json; charset=UTF-8")
        |> send_resp(:unauthorized, Jason.encode!(%{error: "Unauthorized"}))
      end
    else
      conn
      |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(%{error: "Unauthorized"}))
    end
  end
end
