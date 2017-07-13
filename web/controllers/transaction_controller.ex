defmodule HelloPhoenix.TransactionController do
  use HelloPhoenix.Web, :controller

  alias HelloPhoenix.Transaction
  alias HelloPhoenix.User

  def index(conn, _params) do
    transactions = Repo.all(Transaction)
    render(conn, "index.html", transactions: transactions)
  end

  def new(conn, _params) do

    user = Repo.get(User, conn.assigns.current_user.id)

    cur_usd = user.usd
    cur_eur = user.euro
    cur_gold = user.gold

    changeset = Transaction.changeset(%Transaction{cur_usd: cur_usd,
                cur_gold: cur_gold,
                cur_eur: cur_eur,
                cur_usd: cur_usd,
                eur_to_usd: 0,
                usd_to_eur: 0,
                usd_to_gold: 0,
                gold_to_usd: 0})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    changeset = Transaction.changeset(%Transaction{}, transaction_params)

    currentValues = GenServer.call(Finance.DataCacher, :all)

    user = Repo.get(User, conn.assigns.current_user.id)

    cur_usd = user.usd
    cur_eur = user.euro
    cur_gold = user.gold

    {eur_sold, _} = Float.parse(Map.get(transaction_params, "eur_to_usd"))
    current_trading_eur_usd = currentValues[:eur_usd]
    usd_gain = eur_sold * current_trading_eur_usd

    {usd_sold, _} = Float.parse(Map.get(transaction_params, "usd_to_eur"))
    current_trading_usd_eur = currentValues[:usd_eur]
    eur_gain = usd_sold * current_trading_usd_eur

    {gold_to_usd, _} = Float.parse(Map.get(transaction_params, "gold_to_usd"))
    current_trading_gold_usd = currentValues[:gold_usd]

    {usd_to_gold, _} = Float.parse(Map.get(transaction_params, "usd_to_gold"))
    current_trading_usd_gold = currentValues[:usd_gold]

    gold_gain = usd_to_gold * current_trading_usd_gold
    usd_sold = usd_sold + usd_to_gold

    gold_sold = gold_to_usd
    usd_gain = usd_gain + gold_sold * current_trading_gold_usd

    new_usd_float = cur_usd + usd_gain - usd_sold
    new_eur_float = cur_eur + eur_gain - eur_sold
    new_gold_float = cur_gold + gold_gain - gold_sold

    #user_changeset = User.changeset(%User{}, conn.assigns.current_user)
    user_changeset = User.changeset(user,
    %{
        usd: new_usd_float,
        euro: new_eur_float,
        #id: conn.assigns.current_user.id,
        #password: conn.assigns.current_user.password,
        gold: new_gold_float,
        #username: conn.assigns.current_user.username,
    })

    #the if clause is forbidden :D
    invalid_transaction = gold_sold > user.gold or usd_sold > user.usd or  eur_sold > user.euro

    case invalid_transaction do
        true ->
          conn
          |> put_flash(:error, "Invalid transaction.")
          |> redirect(to: transaction_path(conn, :index))

        _ ->
          Repo.insert(changeset)
          Repo.update!(user_changeset)
          conn
          |> put_flash(:info, "Transaction created successfully.")
          |> redirect(to: transaction_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Repo.get!(Transaction, id)
    render(conn, "show.html", transaction: transaction)
  end

  # def edit(conn, %{"id" => id}) do
  #   transaction = Repo.get!(Transaction, id)
  #   changeset = Transaction.changeset(transaction)
  #   render(conn, "edit.html", transaction: transaction, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "transaction" => transaction_params}) do
  #   transaction = Repo.get!(Transaction, id)
  #   changeset = Transaction.changeset(transaction, transaction_params)
  #
  #   case Repo.update(changeset) do
  #     {:ok, transaction} ->
  #       conn
  #       |> put_flash(:info, "Transaction updated successfully.")
  #       |> redirect(to: transaction_path(conn, :show, transaction))
  #     {:error, changeset} ->
  #       render(conn, "edit.html", transaction: transaction, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   transaction = Repo.get!(Transaction, id)
  #
  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(transaction)
  #
  #   conn
  #   |> put_flash(:info, "Transaction deleted successfully.")
  #   |> redirect(to: transaction_path(conn, :index))
  # end
end
