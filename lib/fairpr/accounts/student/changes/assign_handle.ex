defmodule Fairpr.Accounts.Student.Changes.AssignHandle do
  @moduledoc false
  use Ash.Resource.Change

  require Ash.Query

  @impl true
  def change(changeset, _opts, _context) do
    changeset
    |> trim_string(:first_name)
    |> trim_string(:last_name)
    |> trim_string(:middle_initial)
    |> maybe_assign_handle()
  end

  defp trim_string(changeset, attr) do
    case Ash.Changeset.get_attribute(changeset, attr) do
      nil ->
        changeset

      value when is_binary(value) ->
        Ash.Changeset.force_change_attribute(changeset, attr, String.trim(value))

      value ->
        Ash.Changeset.force_change_attribute(changeset, attr, value)
    end
  end

  defp maybe_assign_handle(changeset) do
    data = changeset.data

    first_name = Ash.Changeset.get_attribute(changeset, :first_name)
    last_name = Ash.Changeset.get_attribute(changeset, :last_name)

    cond do
      not is_binary(first_name) or not is_binary(last_name) ->
        changeset

      String.trim(first_name) == "" or String.trim(last_name) == "" ->
        changeset

      should_recompute_handle?(changeset, data) ->
        base = build_base(first_name, last_name)
        exclude_id = if data, do: data.id, else: nil

        handle = first_free_handle(changeset, base, exclude_id)

        Ash.Changeset.force_change_attribute(changeset, :handle, handle)

      true ->
        changeset
    end
  end

  defp should_recompute_handle?(_changeset, nil), do: true

  defp should_recompute_handle?(changeset, data) do
    fn_new = Ash.Changeset.get_attribute(changeset, :first_name)
    ln_new = Ash.Changeset.get_attribute(changeset, :last_name)

    fn_new != data.first_name or ln_new != data.last_name
  end

  defp build_base(first_name, last_name) do
    fn_trim = String.trim(first_name)
    ln_trim = String.trim(last_name)

    first_letter =
      case String.first(ln_trim) do
        nil -> ""
        g -> String.upcase(g)
      end

    fn_trim <> first_letter
  end

  defp candidate_handle(base, 0), do: base
  defp candidate_handle(base, n) when n > 0, do: base <> Integer.to_string(n)

  defp first_free_handle(changeset, base, exclude_id) do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Stream.map(&candidate_handle(base, &1))
    |> Enum.find(fn candidate ->
      is_nil(find_by_handle(changeset, candidate, exclude_id))
    end)
  end

  defp find_by_handle(changeset, handle_value, exclude_id) do
    resource = changeset.resource

    query =
      resource
      |> Ash.Query.for_read(:read)
      |> Ash.Query.filter(handle == ^handle_value)

    query =
      if exclude_id do
        Ash.Query.filter(query, id != ^exclude_id)
      else
        query
      end

    case Ash.read_one(query, authorize?: false) do
      {:ok, nil} -> nil
      {:ok, record} -> record
      {:error, _} -> nil
    end
  end
end
