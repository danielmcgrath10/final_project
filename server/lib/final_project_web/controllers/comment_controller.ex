defmodule FinalProjectWeb.CommentController do
  use FinalProjectWeb, :controller

  alias FinalProject.Comments
  alias FinalProject.Comments.Comment
  alias FinalProjectWeb.SessionController


  action_fallback FinalProjectWeb.FallbackController

  def index(conn, _params) do
    comments = Comments.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params, "session" => session}) do
    if SessionController.authorized?(conn, session["user_id"], session["token"]) do
      with {:ok, %Comment{} = _comment} <- Comments.create_comment(comment_params) do
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
    comment = Comments.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Comments.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id, "session" => session}) do
    comment = Comments.get_comment!(id)
    user_id = session["user_id"]
    if SessionController.authorized?(conn, user_id, session["token"]) do
      if (user_id == comment.user.id) || (user_id == comment.post.user.id) do
        with {:ok, %Comment{}} <- Comments.delete_comment(comment) do
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
