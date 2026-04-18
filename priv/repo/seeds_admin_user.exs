# Dev admin user (requires seeds_roles.exs for the Administrator role).
# Loaded from priv/repo/seeds.exs.
#
#     mix run priv/repo/seeds_admin_user.exs

require Ash.Query

email = "aa@a.c"
password = "Password123456!"

role = Fairpr.Accounts.get_role_by_name!("Administrator", authorize?: false)

user_query =
  Fairpr.Accounts.User
  |> Ash.Query.for_read(:get_by_email, %{email: email})

user =
  case Ash.read_one(user_query, authorize?: false) do
    {:ok, nil} ->
      {:ok, created} =
        Fairpr.Accounts.User
        |> Ash.Changeset.for_create(:register_with_password, %{
          email: email,
          password: password,
          password_confirmation: password
        })
        |> Ash.Changeset.force_change_attribute(:first_name, "Adam")
        |> Ash.Changeset.force_change_attribute(:middle_initial, "A.")
        |> Ash.Changeset.force_change_attribute(:last_name, "Administrator")
        |> Ash.create(authorize?: false)

      {:ok, _} =
        Fairpr.Repo.query(
          "UPDATE users SET confirmed_at = $1::timestamptz WHERE id::text = $2",
          [
            DateTime.utc_now() |> DateTime.truncate(:microsecond),
            to_string(created.id)
          ]
        )

      created

    {:ok, existing} ->
      existing

    {:error, error} ->
      raise error
  end

Fairpr.Accounts.update_user!(
  user,
  %{
    first_name: "Adam",
    middle_initial: "A.",
    last_name: "Administrator",
    roles: [role.id]
  },
  authorize?: false
)

# Ensure confirmed_at so password sign-in works (register does not auto-confirm).
{:ok, _} =
  Fairpr.Repo.query(
    "UPDATE users SET confirmed_at = COALESCE(confirmed_at, $1::timestamptz) WHERE email::text = $2",
    [DateTime.utc_now() |> DateTime.truncate(:microsecond), email]
  )
