defmodule VoldersWeb.UserController do
  use VoldersWeb, :controller

  alias Volders.Accounts
  alias Volders.Accounts.User



  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> put_session(:user, %{
          id: user.id,
          full_name: user.full_name,
          email: user.email
        })
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
