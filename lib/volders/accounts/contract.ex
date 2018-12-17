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

end
