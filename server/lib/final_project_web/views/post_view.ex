defmodule FinalProjectWeb.PostView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.PostView
  alias FinalProjectWeb.UserView
  alias FinalProjectWeb.LikeView
  alias FinalProjectWeb.CommentView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      location: post.location,
      drinkName: post.drinkName,
      # photo_hash: post.photo_hash,
      rating: post.rating,
      caption: post.caption,
      timestamp: post.timestamp,
      user: render_one(post.user, UserView, "user.json"),
      comments: render_many(post.comments, CommentView, "comment.json"),
      likes: render_many(post.likes, LikeView, "like.json")
    }
  end
end
