defmodule VoldersWeb.UserControllerTest do
  use VoldersWeb.ConnCase

  alias Volders.Accounts

    @create_attrs %{email: "test@test.com", password: "password123456", password_confirmation: "password123456" ,full_name: "Test McTest"}
    @invalid_attrs %{email: nil, password: nil, password_confirmation: "nil",full_name: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end


  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get conn, user_path(conn, :new)
      assert html_response(conn, 200) =~ "Signup"
    end
  end

  describe "create user" do
    test "redirects to index", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs

      conn = get conn, page_path(conn, :index)
      assert html_response(conn, 200) =~  "Welcome to Volders Contracts Managment App!"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Signup"
    end
  end


end
