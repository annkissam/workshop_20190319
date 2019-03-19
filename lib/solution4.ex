defmodule Solution4 do
  @moduledoc """
  Processing a data file lazily with Flows
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
    |> Flow.from_enumerable()
    |> Flow.map(&String.trim/1)
    |> Flow.partition()
    |> Flow.map(&PokemonApi.get/1)
    |> Flow.map(& &1.name)
    |> Flow.reduce(fn -> %{} end, fn name, acc ->
      Map.update(acc, name, 1, & &1 + 1)
    end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
  end
end
