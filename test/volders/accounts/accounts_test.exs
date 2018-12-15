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
end
                 