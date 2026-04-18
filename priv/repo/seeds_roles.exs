# Populates canonical role names. Loaded from priv/repo/seeds.exs.
#
#     mix run priv/repo/seeds_roles.exs

require Ash.Query

names = ["Director", "Therapist", "Supervisor", "Scholar"]

Enum.each(names, fn name ->
  query =
    Fairpr.Accounts.Role
    |> Ash.Query.for_read(:read)
    |> Ash.Query.filter(name == ^name)

  case Ash.read_one(query, authorize?: false) do
    {:ok, nil} ->
      Fairpr.Accounts.create_role!(%{name: name}, authorize?: false)

    {:ok, _} ->
      :ok

    {:error, error} ->
      raise error
  end
end)
