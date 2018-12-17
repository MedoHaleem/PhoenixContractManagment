defmodule Volders.Accounts.Contract do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volders.Accounts.User


  schema "contracts" do
    field :category, :string
    field :costs, :float
    field :ends_on, :date
    field :vendor, :string
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:vendor, :category, :costs, :ends_on, :user_id])
    |> validate_required([:vendor, :category, :costs, :ends_on, :user_id])
  end
end
