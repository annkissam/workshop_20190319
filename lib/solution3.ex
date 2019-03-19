defmodule Solution3 do
  @moduledoc """
  Processing a data file lazily with tasks
  """

  # @csv_path ~s(./sprites/data)
  @csv_path ~s(./sprites/data_big)

  @doc """
  This function list pokemon in mostly occuring order
  """
  def call(csv_path \\ nil) do
    csv_path = csv_path || @csv_path

    csv_path
    |> File.stream!()
    # assuming the file is properly formatted
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.map(fn id -> Task.async(fn -> PokemonApi.get(id) end) end)
    |> Enum.map(&Task.await(&1, 50_000))
    |> Enum.map(& &1.name)
    |> Enum.reduce(%{}, fn name, acc ->
      Map.update(acc, name, 1, & &1 + 1)
    end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
  end

  @doc """
  This function list pokemon in mostly occuring order
  """
  def bad_call do
    @csv_path
    |> File.stream!()
    # assuming the file is properly formatted
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn id -> Task.async(fn -> PokemonApi.get(id) end) end)
    |> Stream.map(&Task.await/1)
    |> Stream.map(& &1.name)
    |> Enum.to_list()
    |> Enum.reduce(%{}, fn name, acc ->
      Map.update(acc, name, 1, & &1 + 1)
    end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
  end
end
