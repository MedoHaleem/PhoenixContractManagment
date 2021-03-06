defmodule Volders.AccountsTest do
  use Volders.DataCase

  alias Volders.Accounts

  describe "users" do
    alias Volders.Accounts.User

    @valid_attrs %{
      email: "test@test.com",
      password: "password123456",
      password_confirmation: "password123456",
      full_name: "Test McTest"
    }
    @invalid_attrs %{email: nil, password: nil, full_name: nil}

    def user_fixture(attrs \\ %{}) do
      with create_attrs <- Map.merge(@valid_attrs, attrs),
           {:ok, user} <- Accounts.create_user(create_attrs) do
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
      {:error, changeset} =
        user_fixture(%{password: "password123456", password_confirmation: "password789456"})

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

    @valid_user_attrs %{
      email: "test@test.com",
      password: "password123456",
      password_confirmation: "password123456",
      full_name: "Test McTest"
    }
    @valid_attrs %{
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
    @invalid_attrs %{category: nil, costs: nil, ends_on: nil, vendor: nil}


    def contract_fixture(attrs \\ %{}) do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      {:ok, contract} =
        attrs
        |> Enum.into(%{user_id: user.id})
        |> Enum.into(@valid_attrs)
        |> Accounts.create_contract()

       contract
    end

    test "list_contracts/0 returns all contracts" do
      contract = contract_fixture()
      assert Accounts.list_contracts() == [contract]
    end

    test "list_user_contracts/1 returns all user contracts" do
      contract = contract_fixture()
      assert Accounts.list_user_contracts(contract.user_id) == [contract]
    end

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_fixture()
      assert Accounts.get_contract!(contract.id) == contract
    end

    test "create_contract/1 with valid data creates a contract" do
      contract = contract_fixture()
      assert contract.category == "Internet"
      assert contract.costs == 120.5
      assert contract.ends_on == Date.utc_today()
      assert contract.vendor == "Vodafone"
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_contract(@invalid_attrs)
    end

    test "create_contract/1 fails to create the contract when cost is 0 or lower" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      invalid_attrs = Enum.into(@valid_attrs, %{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Accounts.create_contract(Map.merge(invalid_attrs, %{costs: 0}))
      assert {:error, %Ecto.Changeset{}} = Accounts.create_contract(Map.merge(invalid_attrs, %{costs: -100}))
    end

    test "create_contract/1 fails to create the contract when date is in the past" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      invalid_attrs = Enum.into(@valid_attrs, %{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Accounts.create_contract(Map.merge(invalid_attrs, %{ends_on: ~D[2010-04-17]}))
    end

    test "create_contract/1 fails to create the contract when Vednor is not in the list" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      invalid_attrs = Enum.into(@valid_attrs, %{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Accounts.create_contract(Map.merge(invalid_attrs, %{vendor: "test"}))
    end

    test "create_contract/1 fails to create the contract when Category doesn't belong to Vendor" do
      {:ok, user} = Accounts.create_user(@valid_user_attrs)
      invalid_attrs = Enum.into(@valid_attrs, %{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Accounts.create_contract(Map.merge(invalid_attrs, %{category: "test"}))
    end

    # Elixir Already give an argument error cannot parse "2020-17-17" as date, reason: :invalid_date, which get called automatically with strcut type Date
    # Don't know how to assert it
    # test "create_contract/1 fails to create the contract when ends_on is not a valid format" do
    #   {:ok, user} = Accounts.create_user(@valid_user_attrs)
    #   invalid_attrs = Enum.into(@valid_attrs, %{user_id: user.id})
    #   assert {:error, %Ecto.Changeset{}} = Accounts.create_contract(Map.merge(invalid_attrs, %{ends_on: ~D[2020-17-17]}))
    # end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      assert {:ok, contract} = Accounts.update_contract(contract, @update_attrs)
      assert %Contract{} = contract
      assert contract.category == "Internet"
      assert contract.costs == 456.7
      assert contract.ends_on == Date.utc_today()
      assert contract.vendor == "O2"
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
