defmodule Task1 do
  @moduledoc """
  Documentation for `Task1`.
  """

  require Logger
  @priv_dir :code.priv_dir(:task_1)

  defp set_professions(professions_path) do
    try do
      res =
        Path.join(@priv_dir, professions_path)
        |> File.stream!()
        |> CSV.decode!([{:headers, true}])
        |> Enum.reduce(%{}, fn x, acc ->
          %{"id" => id, "name" => name, "category_name" => category_name} = x
          Map.put(acc, id, %{"name" => name, "category_name" => category_name})
        end)

      {:ok, res}
    rescue
      e ->
        Logger.error("Error through setting professions with reason: #{inspect(e)}")
        {:error, :professions}
    end
  end

  defp group_by_continent(row, acc, professions, continents) do
    try do
      %{
        "profession_id" => id,
        "contract_type" => type,
        "name" => name,
        "office_latitude" => latitude,
        "office_longitude" => longtitude
      } = row

      lat = String.to_float(latitude)
      lon = String.to_float(longtitude)

      case find_continent(continents, lat, lon) do
        nil ->
          x = get_from_map(row, professions, id)
          Map.put(acc, "unknown", [x | acc["unknown"]])

        {continent, _, _} ->
          x = get_from_map(row, professions, id)
          Map.put(acc, continent, [x | acc[continent]])
      end
    rescue
      ArgumentError ->
        acc
    end
  end

  defp set_jobs_assoc_professions(jobs_path, res_map, professions, continents) do
    try do
      res =
        Path.join(@priv_dir, jobs_path)
        |> File.stream!()
        |> CSV.decode!([{:headers, true}])
        |> Enum.reduce(res_map, fn x, acc ->
          group_by_continent(x, acc, professions, continents)
        end)

      {:ok, res}
    rescue
      e ->
        Logger.error(
          "Error through setting jobs assoc with professions grouping by continents with reason: #{
            inspect(e)
          }"
        )

        {:error, :jobs}
    end
  end

  def get_grouped_jobs do
    j_assoc_p = fn path, res, professions, continents ->
      set_jobs_assoc_professions(path, res, professions, continents)
    end

    with {:ok, professions_path} <- Confex.fetch_env(:task_1, :professions_csv),
         {:ok, jobs_path} <- Confex.fetch_env(:task_1, :jobs_csv),
         {:ok, res_map} <- Confex.fetch_env(:task_1, :result_map),
         {:ok, continents} = Confex.fetch_env(:task_1, :continents),
         {:ok, professions} <- set_professions(professions_path),
         {:ok, groupped} <- j_assoc_p.(jobs_path, res_map, professions, continents) do
      count_jobs_per_continent(groupped, continents)
    else
      e ->
        Logger.error("Error through data formation with reason: #{inspect(e)}")
        %{}
    end
  end

  def count_jobs_per_continent(map, continents) do
    Enum.reduce(continents, %{}, fn x, acc ->
      {continent, _, _} = x

      res =
        Enum.reduce(map[continent], %{}, fn x, acc ->
          %{"category_name" => type} = x
          Map.put(acc, type, update_count(acc, type) + 1)
        end)

      res = Map.put(res, "TOTAL", calculate_total(res))
      Map.put(acc, continent, res)
    end)
  end

  def calculate_total(map) do
    Enum.reduce(map, 0, fn {k, v}, acc ->
      acc = acc + v
      acc
    end)
  end

  defp update_count(map, type) do
    case map[type] do
      nil -> 0
      val -> val
    end
  end

  defp get_from_map(x, database, id) do
    case database[id] do
      nil ->
        x |> Map.put("category_name", "unknown")

      %{"name" => name, "category_name" => category_name} ->
        x
        |> Map.put("name", name)
        |> Map.put("category_name", category_name)
    end
  end

  # TODO fixme
  defp find_continent(continents, lat, lon) do
    Enum.find(continents, fn {_, e_lat, e_long} ->
      abs(lat) <= abs(e_lat) and abs(lon) <= abs(e_long)
    end)
  end
end
