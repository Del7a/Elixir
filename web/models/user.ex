defmodule HelloPhoenix.User do
  use HelloPhoenix.Web, :model

@moduledoc """
Model for storing user details
"""

  schema "users" do
    field :username, :string
    field :password, :string
    field :usd, :float
    field :euro, :float
    field :gold, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password, :usd, :euro, :gold])
    |> validate_required([:username, :password])
  end
end
