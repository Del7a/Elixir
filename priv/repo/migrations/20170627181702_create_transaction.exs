defmodule HelloPhoenix.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :usd_to_eur, :float
      add :eur_to_usd, :float
      add :usd_to_gold, :float
      add :gold_to_usd, :float
      add :cur_usd, :float
      add :cur_eur, :float
      add :cur_gold, :float

      timestamps()
    end

  end
end
