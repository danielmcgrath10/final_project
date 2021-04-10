defmodule FinalProjectWeb.ReviewView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.ReviewView
  alias FinalProjectWeb.RevCommentView
  alias FinalProjectWeb.VoteView

  def render("index.json", %{reviews: reviews}) do
    %{data: render_many(reviews, ReviewView, "review.json")}
  end

  def render("show.json", %{review: review}) do
    %{data: render_one(review, ReviewView, "review.json")}
  end

  def render("review.json", %{review: review}) do
    %{id: review.id,
      place_id: review.place_id,
      rating: review.rating,
      comments: render_many(review.revcomments, RevCommentView, "rev_comment.json"),
      votes: render_many(review.votes, VoteView, "vote.json")
    }
  end
end
