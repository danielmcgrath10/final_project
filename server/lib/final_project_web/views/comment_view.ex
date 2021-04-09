defmodule FinalProjectWeb.CommentView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.CommentView
  alias FinalProjectWeb.UserView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    user = FinalProject.Users.get_user!(comment.user_id)
    %{id: comment.id,
      body: comment.body,
      user_id: comment.user_id,
      user: render_one(user, UserView, "user.json")
    }
  end
end
