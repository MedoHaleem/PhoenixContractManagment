defmodule VoldersWeb.ContractController do
  use VoldersWeb, :controller
  import Plug.Conn
  plug :authorize_user when action in [:new, :create, :show, :edit, :update, :delete]

  alias Volders.Accounts
  alias Volders.Accounts.Contract

  def index(conn, _params) do
    user = get_session(conn, :user)
    contracts = Accounts.list_user_contracts(user.id)
    render(conn, "index.html", contracts: contracts)
  end

  def new(conn, _params) do
    changeset = Accounts.change_contract(%Contract{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"contract" => contract_params}) do

    with user <- get_session(conn, :user),
    contract_params <- Map.put(contract_params, "user_id", user.id), {:ok, contract} <- Accounts.create_contract(contract_params) do
        conn
        |> put_flash(:info, "Contract created successfully.")
        |> redirect(to: contract_path(conn, :show, contract))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contract = Accounts.get_contract!(id)
    render(conn, "show.html", contract: contract)
  end

  def edit(conn, %{"id" => id}) do
    contract = Accounts.get_contract!(id)
    changeset = Accounts.change_contract(contract)
    render(conn, "edit.html", contract: contract, changeset: changeset)
  end

  def update(conn, %{"id" => id, "contract" => contract_params}) do
    contract = Accounts.get_contract!(id)

    case Accounts.update_contract(contract, contract_params) do
      {:ok, contract} ->
        conn
        |> put_flash(:info, "Contract updated successfully.")
        |> redirect(to: contract_path(conn, :show, contract))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", contract: contract, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contract = Accounts.get_contract!(id)
    {:ok, _contract} = Accounts.delete_contract(contract)

    conn
    |> put_flash(:info, "Contract deleted successfully.")
    |> redirect(to: contract_path(conn, :index))
  end

  defp authorize_user(conn, _params) do
    if Plug.Conn.get_session(conn, :user) do
      conn
    else
      conn
      |> put_flash(:error, "You need to sign in or sign up before continuing.")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end
end
