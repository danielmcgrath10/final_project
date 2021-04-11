# This was inspired by the Class Notes
defmodule FinalProjectWeb.UserController do
  use FinalProjectWeb, :controller

  alias FinalProject.Users
  alias FinalProject.Users.User
  alias FinalProject.Photos

  action_fallback FinalProjectWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    user = Users.get_user_by_email(user_params["email"])
    if user do
      conn
      |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(%{error: "Fail"}))
    else
      photo = user_params["profile_photo"]
      if photo do
        {:ok, hash} = Photos.save_photo(photo.filename, photo.path)

        user_params = user_params
        |> Map.put("photo_hash", hash)

        with {:ok, %User{} = user} <- Users.create_user(user_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_path(conn, :show, user))
          |> render("show.json", user: user)
        end
      else
        with {:ok, %User{} = user} <- Users.create_user(user_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_path(conn, :show, user))
          |> render("show.json", user: user)
        end
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def profile_photo(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _name, data} = Photos.load_photo(user.photo_hash)

    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, data)
  end
end
