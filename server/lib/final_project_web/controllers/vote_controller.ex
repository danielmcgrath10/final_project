defmodule FinalProjectWeb.VoteController do
  use FinalProjectWeb, :controller

  alias FinalProject.Votes
  alias FinalProject.Votes.Vote
  alias FinalProjectWeb.SessionController

  action_fallback FinalProjectWeb.FallbackController

  def index(conn, _params) do
    votes = Votes.list_votes()
    render(conn, "index.json", votes: votes)
  end

  def create(conn, %{"vote" => vote_params, "session" => session}) do
    if SessionController.authorized?(conn, session["user_id"], session["token"]) do
      with {:ok, %Vote{} = vote} <- Votes.create_vote(vote_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.vote_path(conn, :show, vote))
        |> render("show.json", vote: vote)
      end
    else
      conn
      |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(%{error: "Unauthorized"}))
    end
  end

  def show(conn, %{"id" => id}) do
    vote = Votes.get_vote!(id)
    render(conn, "show.json", vote: vote)
  end

  def update(conn, %{"id" => id, "vote" => vote_params}) do
    vote = Votes.get_vote!(id)

    with {:ok, %Vote{} = vote} <- Votes.update_vote(vote, vote_params) do
      render(conn, "show.json", vote: vote)
    end
  end

  def delete(conn, %{"id" => id, "session" => session}) do
    vote = Votes.get_vote!(id)

    if (SessionController.authorized?(conn, session["user_id"], session["token"])) && (session["user_id"] === vote.user_id) do
      with {:ok, %Vote{}} <- Votes.delete_vote(vote) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(%{error: "Unauthorized"}))
    end
  end
end
