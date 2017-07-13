defmodule HelloPhoenix.GuardianToken do
  use HelloPhoenix.Web, :model

  alias HelloPhoenix.Repo
  alias HelloPhoenix.GuardianSerializer
@moduledoc """
This model is used to store user tokens for authentication
"""


  @primary_key {:jti, :string, []}
  @derive {Phoenix.Param, key: :jti}
  schema "guardian_tokens" do
    field :aud, :string
    field :iss, :string
    field :sub, :string
    field :exp, :integer
    field :jwt, :string
    field :claims, :map
    field :typ, :string

    timestamps()
  end


@doc """
Searches for authenticated user
"""
  def for_user(user) do
    case GuardianSerializer.for_token(user) do
      {:ok, aud} ->
        (from t in HelloPhoenix.GuardianToken, where: t.sub == ^aud)
          |> Repo.all
      _ -> []
    end
  end
end
