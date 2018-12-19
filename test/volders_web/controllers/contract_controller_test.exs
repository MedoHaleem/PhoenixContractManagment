defmodule VoldersWeb.ContractControllerTest do
  use VoldersWeb.ConnCase

  alias Volders.Accounts

  @create_attrs %{
    category: "Internet",
    costs: 120.5,
    ends_on: Date.utc_today(),
    vendor: "Vodafone"
  }
  @update_attrs %{
    category: "Internet",
    costs: 456.7,
    ends_on: Date.utc_today(),
    vendor: "O2"
  }
  @invalid_attrs %{category: nil, costs: nil, ends_on: Date.utc_today(), vendor: nil}

  defp login(conn, user) do
    conn |> post("/sessions", %{email: user.email, password: user.password})
  end

  setup do
    conn = build_conn()

    {:ok, user} =
      Volders.Accounts.create_user(%{
        full_name: "test",
        email: "test@test.com",
        password: "password1234",
        password_confirmation: "password1234"
      })

    {:ok, contract} = Accounts.create_contract(Enum.into(@create_attrs, %{user_id: user.id}))

    {:ok, conn: conn, user: user, contract: contract}
  end

  describe "index" do
    test "lists all contracts if logged in", %{conn: conn, user: user} do
      conn = login(conn, user) |> get("/contract")
      assert html_response(conn, 200) =~ "My Contracts"
    end

    test "redirect to login page if not logged in", %{conn: conn} do
      conn = get(conn, contract_path(conn, :index))
      assert redirected_to(conn) == "/login"
    end
  end

  describe "new contract" do
    test "renders form", %{conn: conn, user: user} do
      conn = login(conn, user) |> get(contract_path(conn, :new))
      assert html_response(conn, 200) =~ "New Contract"
    end

    test "redirect to login page if not logged in", %{conn: conn} do
      conn = get(conn, contract_path(conn, :new))
      assert redirected_to(conn) == "/login"
    end
  end

  describe "create contract" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn =
        login(conn, user)
        |> post("/contract", %{"contract" => @create_attrs})

      assert redirected_to(conn) == contract_path(conn, :index)

      conn = get(conn, contract_path(conn, :index))
      assert html_response(conn, 200) =~ "My Contracts"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        login(conn, user)
        |> post(contract_path(conn, :create), contract: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Contract"
    end
  end

  describe "edit contract" do
    test "redirect to login page if not logged in", %{conn: conn, contract: contract} do
      conn = get(conn, contract_path(conn, :edit, contract))
      assert redirected_to(conn) == "/login"
    end

    test "renders form for editing chosen contract", %{conn: conn, contract: contract, user: user} do
      conn = login(conn, user) |> get(contract_path(conn, :edit, contract))
      assert html_response(conn, 200) =~ "Edit Contract"
    end
  end

  describe "update contract" do
    test "redirects when data is valid", %{conn: conn, user: user, contract: contract} do
      conn =
        login(conn, user) |> put(contract_path(conn, :update, contract), contract: @update_attrs)

      assert redirected_to(conn) == contract_path(conn, :show, contract)

      conn = get(conn, contract_path(conn, :index))
      assert html_response(conn, 200) =~ "My Contracts"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user, contract: contract} do
      conn =
        login(conn, user) |> put(contract_path(conn, :update, contract), contract: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Contract"
    end
  end
end
