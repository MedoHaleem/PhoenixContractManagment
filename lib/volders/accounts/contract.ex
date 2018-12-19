defmodule Volders.Accounts.Contract do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volders.Accounts.User

  schema "contracts" do
    field(:category, :string)
    field(:costs, :float)
    field(:ends_on, :date)
    field(:vendor, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:vendor, :category, :costs, :ends_on, :user_id])
    |> validate_required([:vendor, :category, :costs, :ends_on, :user_id])
    |> validate_inclusion(:vendor, ["Vodafone", "O2", "Vattenfall"], message: "Please choose a valid vendor from the list")
    |> validate_category(attrs)
    |> validate_number(:costs, greater_than: 0, message: "The cost value is invalid")
    |> validate_date_in_the_future(:ends_on)
  end

  defp validate_date_in_the_future(changeset, field) do
    validate_change(changeset, field, fn _field, ends_on ->
      case Date.compare(ends_on, Date.utc_today()) do
        :lt -> [{field, "can't be in the past"}]
        _ -> []
      end
    end)
  end

  # I just realized that there  validate_inclusion
  # def validate_vendor(changeset, field) do
  #   vendors = ["Vodafone", "O2", "Vattenfall"]
  #   validate_change(changeset, field, fn _field, vendor ->
  #     case Enum.any?(vendors, fn x -> x == vendor end) do
  #       false -> [{field, "invalid vendor please pick a valid one from the list"}]
  #       true -> []
  #     end
  #   end)
  # end


  def validate_category(changeset, %{vendor: "Vodafone"}) do
    changeset
    |> validate_inclusion(:category, ["Internet", "DSL", "Phone", "Mobile Phone"], message: "this category doesn't belong to vendor")
  end


  def validate_category(changeset, %{vendor: "O2"}) do
    changeset
    |> validate_inclusion(:category, ["Internet", "DSL", "Phone", "Mobile Phone"],  message: "this category doesn't belong to vendor")
  end

  def validate_category(changeset, %{vendor: "Vattenfall"}) do
    changeset
    |> validate_inclusion(:category, ["Internet", "DSL", "Phone", "Mobile Phone"],  message: "this category doesn't belong to vendor")
  end

  def validate_category(changeset, _attrs) do
    changeset
  end



end
