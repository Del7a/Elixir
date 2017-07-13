defmodule HelloPhoenix.TransactionControllerTest do
  use HelloPhoenix.ConnCase

  alias HelloPhoenix.Transaction
  @valid_attrs %{cur_eur: "120.5", cur_gold: "120.5", cur_usd: "120.5", eur_to_usd: "120.5", gold_to_usd: "120.5", usd_to_eur: "120.5", usd_to_gold: "120.5"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, transaction_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing transactions"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, transaction_path(conn, :new)
    assert html_response(conn, 200) =~ "New transaction"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, transaction_path(conn, :create), transaction: @valid_attrs
    assert redirected_to(conn) == transaction_path(conn, :index)
    assert Repo.get_by(Transaction, @valid_attrs)
  end

  test "shows chosen resource", %{conn: conn} do
    transaction = Repo.insert! %Transaction{}
    conn = get conn, transaction_path(conn, :show, transaction)
    assert html_response(conn, 200) =~ "Show transaction"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, transaction_path(conn, :show, -1)
    end
  end

end
