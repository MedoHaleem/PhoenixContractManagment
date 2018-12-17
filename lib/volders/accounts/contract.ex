defmodule Volders.Accounts.Contract do
  use Ecto.Schema
  import Ecto.Changeset


  schema "contracts" do
    field :category, :string
    field :costs, :float
    field :ends_on, :date
    field :vendor, :string

    timestamps()
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:vendor, :category, :costs, :ends_on])
    |> validate_required([:vendor, :category, :costs, :ends_on])
  end
end
