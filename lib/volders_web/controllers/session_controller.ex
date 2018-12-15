defmodule VoldersWeb.SessionController do
  use VoldersWeb, :controller
  alias Volders.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user)
    |> put_flash(:info, "logged out successfully")
    |> redirect(to: "/")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    with user <- Accounts.get_user_by_email!(email), {:ok, login_user} <- login(user, password) do
      conn
      |> put_flash(:info, "Logged in successfully!")
      |> put_session(:user, %{
        id: login_user.id,
        full_name: login_user.full_name,
        email: login_user.email
      })
      |> redirect(to: "/")
      else
        {:error, _} -> conn |> put_flash(:error, "Invalid email/password") |> render("new.html")
    end
  end
  defp login(user, password) do
    Comeonin.Bcrypt.check_pass(user, password)
  end
end
