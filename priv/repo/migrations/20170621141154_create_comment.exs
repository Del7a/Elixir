defmodule HelloPhoenix.Repo.Migrations.CreateComment do
  use Ecto.Migration

#TODO remove
  def change do
    create table(:comments) do
      add :body, :string

      timestamps()
    end

  end
end
