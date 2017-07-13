defmodule HelloPhoenix.Repo.Migrations.CreateUsers do
  use Ecto.Migration

@doc """
  Defines the user table that holds
  user information and current net worth
"""
  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :email, :string
      add :usd, :float
      add :euro, :float
      add :gold, :float

      timestamps()
    end

    create unique_index(:users, [:username])
  end
end
