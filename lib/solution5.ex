defmodule Solution5 do
  @moduledoc """
  Processing a data file and running long-term operations on it
  """

  # @csv_path ~s(./sprites/data)
  @csv_path ~s(./sprites/data_big)

  @doc """
  This function list pokemon in mostly occuring order
  """
  def call(csv_path \\ nil) do
    csv_path = csv_path || @csv_path

    init(csv_path)

    most_occuring()
  end

  @doc """
  This functions stores the list of pokemon InMemory to run long term operations
  on it
  """
  def init(csv_path) do
    csv_path
    |> File.stream!()
    # assuming the file is properly formatted
    |> Flow.from_enumerable()
    |> Flow.map(&String.trim/1)
    |> Flow.partition()
    |> Flow.map(&PokemonApi.get/1)
    |> Flow.map(&PokemonBox.add/1)
    |> Flow.run()
  end

  @doc """
  This function list pokemon in mostly occuring order
  """
  def most_occuring do
    PokemonBox.list()
    |> Flow.from_enumerable()
    |> Flow.map(& &1.name)
    |> Flow.partition()
    |> Flow.reduce(fn -> %{} end, fn name, acc ->
      Map.update(acc, name, 1, & &1 + 1)
    end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
  end

  @doc """
  This function list pokemon types in mostly occuring order
  """
  def most_occuring_types do
    PokemonBox.list()
    |> Flow.from_enumerable()
    |> Flow.flat_map(& &1.types)
    |> Flow.partition()
    |> Flow.reduce(fn -> %{} end, fn type, acc ->
      Map.update(acc, type, 1, & &1 + 1)
    end)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
  end
end
