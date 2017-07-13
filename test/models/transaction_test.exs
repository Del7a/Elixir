defmodule HelloPhoenix.TransactionTest do
  use HelloPhoenix.ModelCase

  alias HelloPhoenix.Transaction

  @valid_attrs %{cur_eur: "120.5", cur_gold: "120.5", cur_usd: "120.5", eur_to_usd: "120.5", gold_to_usd: "120.5", usd_to_eur: "120.5", usd_to_gold: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @invalid_attrs)
    refute changeset.valid?
  end
end
