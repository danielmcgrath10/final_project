defmodule FinalProjectWeb.FeedChannel do
  use FinalProjectWeb, :channel

  @impl true
  def join("feed:*"<>name, payload, socket) do
    {:ok, socket}
  end

end
