defmodule FinalProjectWeb.ReviewController do
  use FinalProjectWeb, :controller

  alias FinalProject.Reviews
  alias FinalProject.Reviews.Review
  alias FinalProjectWeb.SessionController

  action_fallback FinalProjectWeb.FallbackController

  def index(conn, %{"input" => input, "user_id" => user_id, "token" => token}) do
    apikey = "AIzaSyDbjo2l0isKuzvgy9-kygM25p3jLjgL3nk"
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{input}&inputtype=textquery&key=#{apikey}&fields=business_status,formatted_address,icon,name,photos,geometry,opening_hours,place_id"

    if SessionController.authorized?(conn, user_id, token) do
      # This is taken from the documentation of HTTPoison
      case HTTPoison.get(URI.encode(url)) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, json} = Jason.decode(body)
          candidates = json["candidates"]
          if !Enum.empty?(candidates) do
            cand = List.first(candidates)
            place_id = cand["place_id"]
            review = Reviews.get_review(place_id)
            if review do
              resbody = %{
                place: json,
                review: FinalProjectWeb.ReviewView.render("show.json", review: review)
              }
              conn
              |> put_resp_header(
                "content-type",
              "application/json; charset=UTF-8")
              |> send_resp(200, Jason.encode!(resbody))
            else
              conn
              |> put_resp_header(
                "content-type",
              "application/json; charset=UTF-8")
              |> send_resp(200, Jason.encode!(%{place: json}))
            end
          else
            send_resp(conn, :no_content, "404")
          end
        {:ok, %HTTPoison.Response{status_code: 404}} ->
          send_resp(conn, :no_content, "404")
        {:error, %HTTPoison.Error{reason: reason}} ->
          send_resp(conn, :no_content, "Error")
      end
    else
      conn
      |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(%{error: "Unauthorized"}))
    end
  end

  def index(conn, %{"id" => id, "user_id" => user_id, "token" => token}) do
    if SessionController.authorized?(conn, user_id, token) do
      review = Reviews.get_review!(id)
      render(conn, "show.json", review: review)
    else
      conn
      |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(%{error: "Unauthorized"}))
    end
  end

  def create(conn, %{"review" => review_params, "session" => session}) do
    if SessionController.authorized?(conn, session["user_id"], session["token"]) do
      with {:ok, %Review{} = review} <- Reviews.create_review(review_params) do
        newRev = Reviews.get_review!(review.id)
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.review_path(conn, :show, newRev))
        |> render("show.json", review: newRev)
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
    review = Reviews.get_review!(id)
    render(conn, "show.json", review: review)
  end

  def update(conn, %{"id" => id, "review" => review_params}) do
    review = Reviews.get_review!(id)

    with {:ok, %Review{} = review} <- Reviews.update_review(review, review_params) do
      render(conn, "show.json", review: review)
    end
  end

  def delete(conn, %{"id" => id}) do
    review = Reviews.get_review!(id)

    with {:ok, %Review{}} <- Reviews.delete_review(review) do
      send_resp(conn, :no_content, "")
    end
  end
end
