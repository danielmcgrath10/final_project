defmodule FinalProjectWeb.PostView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.PostView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      name: post.name,
      lat: post.lat,
      lon: post.lon,
      drinkName: post.drinkName,
      # photo_hash: post.photo_hash,
      rating: post.rating,
      caption: post.caption,
      timestamp: post.timestamp}
  end
end
