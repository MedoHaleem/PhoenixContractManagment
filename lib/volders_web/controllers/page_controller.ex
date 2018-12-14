defmodule VoldersWeb.PageController do
  use VoldersWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
