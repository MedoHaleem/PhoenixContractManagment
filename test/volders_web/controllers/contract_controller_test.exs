defmodule VoldersWeb.ContractControllerTest do
  use VoldersWeb.ConnCase

  alias Volders.Accounts

  @create_attrs %{category: "some category", costs: 120.5, ends_on: ~D[2010-04-17], vendor: "some vendor"}
  @update_attrs %{category: "some updated category", costs: 456.7, ends_on: ~D[2011-05-18], vendor: "some updated vendor"}
  @invalid_attrs %{category: nil, costs: nil, ends_on: nil, vendor: nil}

  def fixture(:contract) do
    {:ok, contract} = Accounts.create_contract(@create_attrs)
    contract
  end

  describe "index" do
    test "lists all contracts", %{conn: conn} do
      conn = get conn, contract_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Contracts"
    end
  end

  describe "new contract" do
    test "renders form", %{conn: conn} do
      conn = get conn, contract_path(conn, :new)
      assert html_response(conn, 200) =~ "New Contract"
    end
  end

  describe "create contract" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, contract_path(conn, :create), contract: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == contract_path(conn, :show, id)

      conn = get conn, contract_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Contract"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, contract_path(conn, :create), contract: @invalid_attrs
      assert html_response(conn, 200) =~ "New Contract"
    end
  end

  describe "edit contract" do
    setup [:create_contract]

    test "renders form for editing chosen contract", %{conn: conn, contract: contract} do
      conn = get conn, contract_path(conn, :edit, contract)
      assert html_response(conn, 200) =~ "Edit Contract"
    end
  end

  describe "update contract" do
    setup [:create_contract]

    test "redirects when data is valid", %{conn: conn, contract: contract} do
      conn = put conn, contract_path(conn, :update, contract), contract: @update_attrs
      assert redirected_to(conn) == contract_path(conn, :show, contract)

      conn = get conn, contract_path(conn, :show, contract)
      assert html_response(conn, 200) =~ "some updated category"
    end

    test "renders errors when data is invalid", %{conn: conn, contract: contract} do
      conn = put conn, contract_path(conn, :update, contract), contract: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Contract"
    end
  end

  describe "delete contract" do
    setup [:create_contract]

    test "deletes chosen contract", %{conn: conn, contract: contract} do
      conn = delete conn, contract_path(conn, :delete, contract)
      assert redirected_to(conn) == contract_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, contract_path(conn, :show, contract)
      end
    end
  end

  defp create_contract(_) do
    contract = fixture(:contract)
    {:ok, contract: contract}
  end
end
