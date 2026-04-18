# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fairpr.Repo.insert!(%Fairpr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

seeds_roles = Path.join(__DIR__, "seeds_roles.exs")
Code.require_file(seeds_roles)
