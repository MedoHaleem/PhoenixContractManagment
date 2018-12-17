defmodule Volders.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :full_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end


  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8, message: "The password is too short")
    |> validate_confirmation(:password, message: "The password confirmation doesn't match!")
    |> encrypt_password()
    |> validate_required([:full_name, :email, :password, :password_confirmation])
    |> unique_constraint(:email, message: "This email is already taken")
  end

  @spec encrypt_password(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp encrypt_password(changeset) do
    with password when not is_nil(password) <- get_change(changeset, :password) do
      put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
    else
      _ -> changeset
    end
  end
end
