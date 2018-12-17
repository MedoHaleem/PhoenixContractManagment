defmodule Volders.AccountsTest do
  use Volders.DataCase

  alias Volders.Accounts

  describe "users" do
    alias Volders.Accounts.User

    @valid_attrs %{email: "test@test.com", password: "password123456", password_confirmation: "password123456" ,full_name: "Test McTest"}
    @invalid_attrs %{email: nil, password: nil, full_name: nil}

    def user_fixture(attrs \\ %{}) do
      with create_attrs <- Map.merge(@valid_attrs, attrs),
           {:ok, user} <- Accounts.create_user(create_attrs)
      do
        # these are virtual fields so it won't be pulled from the database, we simulate that here
        user |> Map.merge(%{password: nil, password_confirmation: nil})
      else
        error -> error
      end
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "test@test.com"
      assert user.full_name == "Test McTest"
    end


    test "create_user/1 fails to create the user when email is not a valid format" do
      {:error, changeset} = user_fixture(%{email: "test.com"})
      assert !changeset.valid?
    end

    test "create_user/1 fails to create the user when password is too short" do
      {:error, changeset} = user_fixture(%{password: "pass", password_confirmation: "pass"})
      assert !changeset.valid?
    end

    test "create_user/1 fails to create the user when the password and the password_confirmation don't match" do
      {:error, changeset} = user_fixture(%{password: "password123456", password_confirmation: "password789456"})
      assert !changeset.valid?
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "get_user_by_email/1 returns the user with the matching email" do
      user = user_fixture()
      assert Accounts.get_user_by_email!(user.email)
    end

    test "get_user_by_email/1 returns nil with no matching email" do
      assert is_nil(Accounts.get_user_by_email!("fail"))
    end

  end

  describe "contracts" do
    alias Volders.Accounts.Contract

    @valid_attrs %{category: "some category", costs: 120.5, ends_on: ~D[2010-04-17], vendor: "some vendor"}
    @update_attrs %{category: "some updated category", costs: 456.7, ends_on: ~D[2011-05-18], vendor: "some updated vendor"}
    @invalid_attrs %{category: nil, costs: nil, ends_on: nil, vendor: nil}

    def contract_fixture(attrs \\ %{}) do
      {:ok, contract} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_contract()

      contract
    end

    test "list_contracts/0 returns all contracts" do
      contract = contract_fixture()
      assert Accounts.list_contracts() == [contract]
    end

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_fixture()
      assert Accounts.get_contract!(contract.id) == contract
    end

    test "create_contract/1 with valid data creates a contract" do
      assert {:ok, %Contract{} = contract} = Accounts.create_contract(@valid_attrs)
      assert contract.category == "some category"
      assert contract.costs == 120.5
      assert contract.ends_on == ~D[2010-04-17]
      assert contract.vendor == "some vendor"
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_contract(@invalid_attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      assert {:ok, contract} = Accounts.update_contract(contract, @update_attrs)
      assert %Contract{} = contract
      assert contract.category == "some updated category"
      assert contract.costs == 456.7
      assert contract.ends_on == ~D[2011-05-18]
      assert contract.vendor == "some updated vendor"
    end

    test "update_contract/2 with invalid data returns error changeset" do
      contract = contract_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_contract(contract, @invalid_attrs)
      assert contract == Accounts.get_contract!(contract.id)
    end

    test "delete_contract/1 deletes the contract" do
      contract = contract_fixture()
      assert {:ok, %Contract{}} = Accounts.delete_contract(contract)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_contract!(contract.id) end
    end

    test "change_contract/1 returns a contract changeset" do
      contract = contract_fixture()
      assert %Ecto.Changeset{} = Accounts.change_contract(contract)
    end
  end
end
