defmodule FinalProjectWeb.FeedChannel do
  use Phoenix.Channel

  @impl true
  def join("feed:" <> name, payload, socket) do
    if authorized?(payload["params"]["session"]["user_id"], payload["params"]["session"]["token"], socket) do
      {:ok, socket}
    else
      {:error, %{reason: "Unauthorized"}}
    end
  end

  defp authorized?(id, token, socket) do
    FinalProjectWeb.SessionController.authorized?(socket, id, token);
  end
end
