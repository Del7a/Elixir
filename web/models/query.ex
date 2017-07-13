defmodule HelloPhoenix.UserQuery do
  import Ecto.Query
  alias HelloPhoenix.User

  def by_username(username) do
    from u in User, where: u.username == ^username
  end
end
