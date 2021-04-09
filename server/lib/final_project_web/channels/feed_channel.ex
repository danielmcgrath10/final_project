defmodule FinalProjectWeb.FeedChannel do
  use Phoenix.Channel
  alias FinalProject.Posts
  alias FinalProjectWeb

  @impl true
  def join("feed:" <> name, payload, socket) do
    if authorized?(payload["params"]["session"]["user_id"], payload["params"]["session"]["token"], socket) do
      posts = Posts.get_recent_posts();
      {:ok, FinalProjectWeb.PostView.render("index.json", %{posts: posts}), socket}
    else
      {:error, %{reason: "Unauthorized"}}
    end
  end

  defp authorized?(id, token, socket) do
    FinalProjectWeb.SessionController.authorized?(socket, id, token);
  end
end
