# Sample student for development. Loaded from priv/repo/seeds.exs.
#
#     mix run priv/repo/seeds_students.exs

require Ash.Query

birthday = ~D[2015-01-01]
intake_date = Date.utc_today()

query =
  Fairpr.Accounts.Student
  |> Ash.Query.for_read(:read)
  |> Ash.Query.filter(first_name == "Sam" and last_name == "Student" and birthday == ^birthday)

case Ash.read_one(query, authorize?: false) do
  {:ok, nil} ->
    Fairpr.Accounts.create_student!(
      %{
        first_name: "Sam",
        last_name: "Student",
        birthday: birthday,
        intake_date: intake_date,
        intake_grade: 5,
        current_grade: 5
      },
      authorize?: false
    )

  {:ok, _} ->
    :ok

  {:error, error} ->
    raise error
end
