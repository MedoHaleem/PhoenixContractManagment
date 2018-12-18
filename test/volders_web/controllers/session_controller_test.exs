defmodule VoldersWeb.SessionControllerTest do
  use VoldersWeb.ConnCase

  alias Volders.Accounts

  @create_attrs %{
    email: "test@test.com",
    password: "password123456",
    password_confirmation: "password123456",
    full_name: "Test McTest"
  }

  setup do
    conn = build_conn()
    {:ok, user} = Accounts.create_user(@create_attrs)
    {:ok, conn: conn, user: user}
  end

  describe "Login User" do
    test "POST /sessions (with valid data)", %{conn: conn, user: user} do
      conn = post(conn, "/sessions", %{email: user.email, password: "password123456"})
      assert redirected_to(conn) == "/contract"
      assert Plug.Conn.get_session(conn, :user)
    end

    test "POST /sessions (with invalid data)", %{conn: conn, user: user} do
      conn = post(conn, "/sessions", %{email: user.email, password: "fail"})
      assert html_response(conn, 200)
      assert is_nil(Plug.Conn.get_session(conn, :user))
    end
  end

  describe "Logout User" do
    test "DELETE /sessions", %{conn: conn, user: user} do
      conn = post(conn, "/sessions", %{email: user.email, password: "password123456"})
      assert Plug.Conn.get_session(conn, :user)
      conn = delete(conn, "/logout")
      assert is_nil(Plug.Conn.get_session(conn, :user))
    end
  end
end
