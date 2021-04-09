defmodule FinalProjectWeb.SessionController do
  use FinalProjectWeb, :controller

  def create(conn, %{"email" => email, "password" => password}) do
    user = FinalProject.Users.authenticate(email, password)

    if user do
      sess = %{
        user_id: user.id,
        email: user.email,
        token: Phoenix.Token.sign(conn, "user_id", user.id)
      }
      conn
      |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
      |> send_resp(:created, Jason.encode!(%{session: sess}))
    else
      conn
      |> put_resp_header(
        "content-type",
        "application/json; charset=UTF-8")
      |> send_resp(:unauthorized, Jason.encode!(%{error: "Invalid Login"}))
    end
  end

  def authorized?(conn, id, token) do
    user = FinalProject.Users.get_user(id)
    if user do
      Phoenix.Token.verify(conn, "user_id", token)
    else
      false
    end
  end
end
