defmodule FinalProjectWeb.RevCommentView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.RevCommentView
  alias FinalProjectWeb.UserView

  def render("index.json", %{revcomment: revcomment}) do
    %{data: render_many(revcomment, RevCommentView, "rev_comment.json")}
  end

  def render("show.json", %{rev_comment: rev_comment}) do
    %{data: render_one(rev_comment, RevCommentView, "rev_comment.json")}
  end

  def render("rev_comment.json", %{rev_comment: rev_comment}) do
    user = FinalProject.Users.get_user!(rev_comment.user_id)
    %{id: rev_comment.id,
      body: rev_comment.body,
      user_id: rev_comment.user_id,
      user: render_one(user, UserView, "user.json")
    }
  end
end
