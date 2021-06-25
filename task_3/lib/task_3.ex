defmodule Task3 do
  @moduledoc """
  Task3 keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  require Logger
  @priv_dir :code.priv_dir(:task_3)

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

  def set_grouped_jobs do
    with {:ok, professions_path} <- Confex.fetch_env(:task_3, :professions_csv),
         {:ok, jobs_path} <- Confex.fetch_env(:task_3, :jobs_csv),
         {:ok, res_map} <- Confex.fetch_env(:task_3, :result_map),
         {:ok, continents} = Confex.fetch_env(:task_3, :continents),
         {:ok, professions} <- set_professions(professions_path) do
      set_jobs_assoc_professions(jobs_path, res_map, professions, continents)
    else
      e ->
        Logger.error("Error through data formation with reason: #{inspect(e)}")
        %{}
    end
  end

  def find_nearest_jobs(map, radius, {lat, lon} = point_b) do
    {:ok, continents} = Confex.fetch_env(:task_3, :continents)
    {continent, _, _} = find_continent(continents, lat, lon)

    IO.inspect(continent)

    Enum.reduce(map[continent], [], fn x, acc ->
      point_a = {String.to_float(x["office_latitude"]), String.to_float(x["office_longitude"])}

      distance = calculate_distance(point_a, point_b)
      build_nearest_jobs_list(x, acc, distance, radius)
    end)
  end

  defp build_nearest_jobs_list(element, acc, distance, radius) when distance <= radius do
    [Map.put(element, "distance", Float.floor(distance, 3)) | acc]
  end

  defp build_nearest_jobs_list(_element, acc, _distance, _radius), do: acc

  defp calculate_distance(a, b) do
    {lat_a, lon_a} = a
    {lat_b, lon_b} = b

    d =
      (ElixirMath.sin(lat_a) * ElixirMath.sin(lat_b) +
         ElixirMath.cos(lat_a) * ElixirMath.cos(lat_b) * ElixirMath.cos(lon_a - lon_b))
      |> ElixirMath.acos()

    # move to config
    r = Confex.get_env(:task_3, :earth_radius)
    d * r
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

  defp find_continent(continents, lat, lon) do
    Enum.find(continents, fn {_, c_lat, c_lon} ->
      compare_latitude(lat, c_lat) and compare_longitude(lon, c_lon)
    end)
  end

  defp compare_latitude(lat, c_lat) when lat < 0 do
    lat >= c_lat
  end

  defp compare_latitude(lat, c_lat) do
    lat <= c_lat
  end

  def compare_longitude(lon, c_lon) when lon < 0 do
    lon <= c_lon
  end

  def compare_longitude(lon, c_lon) do
    lon >= c_lon
  end
end
