defmodule FinalProjectWeb.LikeView do
  use FinalProjectWeb, :view
  alias FinalProjectWeb.LikeView

  def render("index.json", %{likes: likes}) do
    %{data: render_many(likes, LikeView, "like.json")}
  end

  def render("show.json", %{like: like}) do
    %{data: render_one(like, LikeView, "like.json")}
  end

  def render("like.json", %{like: like}) do
    %{id: like.id,
      value: like.value,
      user_id: like.user_id
    }
  end
end
