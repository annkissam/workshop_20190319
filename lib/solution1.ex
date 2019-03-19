defmodule Solution1 do
  @moduledoc """
  Processing a data file without concurrency
  """

  # @csv_path ~s(./sprites/data)
  @csv_path ~s(./sprites/data_big)

  @doc """
  This function list pokemon in mostly occuring order
  """
  def call(csv_path \\ nil) do
    csv_path = csv_path || @csv_path

    csv_path
    |> File.read!()
    |> String.split()
    # assuming the file is properly formatted
    |> Enum.map(&String.trim/1)
    |> Enum.to_list()
    |> Enum.map(&PokemonApi.get/1)
    |> Enum.map(& &1.name)
    |> Enum.reduce(%{}, fn name, acc ->
      Map.update(acc, name, 1, & &1 + 1)
    end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
  end
end
