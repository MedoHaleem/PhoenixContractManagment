defmodule Volders.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add :vendor, :string
      add :category, :string
      add :costs, :float
      add :ends_on, :date
      add :user_id, references(:users)

      timestamps()
    end

  end
end
