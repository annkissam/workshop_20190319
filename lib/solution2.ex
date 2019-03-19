defmodule Solution2 do
  @moduledoc """
  Processing a data file lazily without concurrency
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
    |> Stream.map(&PokemonApi.get/1)
    |> Stream.map(& &1.name)
    |> Enum.to_list()
    |> Enum.reduce(%{}, fn name, acc ->
      Map.update(acc, name, 1, & &1 + 1)
    end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
  end
end
