defmodule VoldersWeb.PageControllerTest do
  use VoldersWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Volders Contracts Managment App!"
  end
end
