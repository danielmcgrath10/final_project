defmodule FinalProjectWeb.RevCommentControllerTest do
  use FinalProjectWeb.ConnCase

  alias FinalProject.RevComments
  alias FinalProject.RevComments.RevComment

  @create_attrs %{
    body: "some body"
  }
  @update_attrs %{
    body: "some updated body"
  }
  @invalid_attrs %{body: nil}

  def fixture(:rev_comment) do
    {:ok, rev_comment} = RevComments.create_rev_comment(@create_attrs)
    rev_comment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all revcomment", %{conn: conn} do
      conn = get(conn, Routes.rev_comment_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create rev_comment" do
    test "renders rev_comment when data is valid", %{conn: conn} do
      conn = post(conn, Routes.rev_comment_path(conn, :create), rev_comment: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.rev_comment_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some body"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.rev_comment_path(conn, :create), rev_comment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update rev_comment" do
    setup [:create_rev_comment]

    test "renders rev_comment when data is valid", %{conn: conn, rev_comment: %RevComment{id: id} = rev_comment} do
      conn = put(conn, Routes.rev_comment_path(conn, :update, rev_comment), rev_comment: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.rev_comment_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some updated body"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, rev_comment: rev_comment} do
      conn = put(conn, Routes.rev_comment_path(conn, :update, rev_comment), rev_comment: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete rev_comment" do
    setup [:create_rev_comment]

    test "deletes chosen rev_comment", %{conn: conn, rev_comment: rev_comment} do
      conn = delete(conn, Routes.rev_comment_path(conn, :delete, rev_comment))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.rev_comment_path(conn, :show, rev_comment))
      end
    end
  end

  defp create_rev_comment(_) do
    rev_comment = fixture(:rev_comment)
    %{rev_comment: rev_comment}
  end
end
