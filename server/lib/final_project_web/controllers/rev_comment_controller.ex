defmodule FinalProjectWeb.RevCommentController do
  use FinalProjectWeb, :controller

  alias FinalProject.RevComments
  alias FinalProject.RevComments.RevComment
  alias FinalProjectWeb.SessionController

  action_fallback FinalProjectWeb.FallbackController

  def index(conn, _params) do
    revcomment = RevComments.list_revcomment()
    render(conn, "index.json", revcomment: revcomment)
  end

  def create(conn, %{"rev_comment" => rev_comment_params, "session" => session}) do
    if SessionController.authorized?(conn, session["user_id"], session["token"]) do
      with {:ok, %RevComment{} = rev_comment} <- RevComments.create_rev_comment(rev_comment_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.rev_comment_path(conn, :show, rev_comment))
        |> render("show.json", rev_comment: rev_comment)
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
    rev_comment = RevComments.get_rev_comment!(id)
    render(conn, "show.json", rev_comment: rev_comment)
  end

  def update(conn, %{"id" => id, "rev_comment" => rev_comment_params}) do
    rev_comment = RevComments.get_rev_comment!(id)

    with {:ok, %RevComment{} = rev_comment} <- RevComments.update_rev_comment(rev_comment, rev_comment_params) do
      render(conn, "show.json", rev_comment: rev_comment)
    end
  end

  def delete(conn, %{"id" => id, "session" => session}) do
    rev_comment = RevComments.get_rev_comment!(id)

    if (SessionController.authorized?(conn, session["user_id"], session["token"])) && (session["user_id"] == rev_comment.user_id) do
      with {:ok, %RevComment{}} <- RevComments.delete_rev_comment(rev_comment) do
        send_resp(conn, :no_content, "")
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
