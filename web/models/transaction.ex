defmodule HelloPhoenix.Transaction do
  use HelloPhoenix.Web, :model
@moduledoc """
Model for storing user transactions
"""

  schema "transactions" do
    field :usd_to_eur, :float
    field :eur_to_usd, :float
    field :usd_to_gold, :float
    field :gold_to_usd, :float
    field :cur_usd, :float
    field :cur_eur, :float
    field :cur_gold, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:usd_to_eur, :eur_to_usd, :usd_to_gold, :gold_to_usd, :cur_usd, :cur_eur, :cur_gold])
    |> validate_required([:usd_to_eur, :eur_to_usd, :usd_to_gold, :gold_to_usd, :cur_usd, :cur_eur, :cur_gold])
  end
end
