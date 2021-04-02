defmodule FinalProjectWeb.SessionController do
  use FinalProjectWeb, :controller

  def create(conn, %{"name" => name, "password" => password}) do
    user = FinalProjectWeb.Users.authenticate(name, password)

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
      |> send_resp(:unauthorized, Jason.encode!(%{error: "Fail"}))
    end
  end
end
