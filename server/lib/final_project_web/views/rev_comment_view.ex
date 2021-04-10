defmodule FinalProjectWeb.RevCommentView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.RevCommentView

  def render("index.json", %{revcomment: revcomment}) do
    %{data: render_many(revcomment, RevCommentView, "rev_comment.json")}
  end

  def render("show.json", %{rev_comment: rev_comment}) do
    %{data: render_one(rev_comment, RevCommentView, "rev_comment.json")}
  end

  def render("rev_comment.json", %{rev_comment: rev_comment}) do
    %{id: rev_comment.id,
      body: rev_comment.body}
  end
end
