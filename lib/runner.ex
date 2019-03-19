defmodule Runner do
  @moduledoc """
  Runs a solution and updates corresponding benchmark file
  """

  require Logger

  def run_all() do
    [
      Solution1,
      Solution2,
      Solution3,
      Solution4,
      Solution5,
    ]
    |> Enum.each(&run/1)
  end

  def run(solution_mod) do
    {time, _} = :timer.tc(fn -> solution_mod.call() end)

    update_benchmarks(solution_mod, time)
    update_average(solution_mod)

    Logger.info("#{solution_mod} - #{time}")
  end

  defp update_benchmarks(solution_mod, time) do
    solution_mod
    |> file_name()
    |> File.open([:append], fn file ->
      IO.write(file, time)
      IO.write(file, "\n")
    end)
  end

  defp update_average(solution_mod) do
    average_time = calculate_average(solution_mod)

    solution_mod
    |> average_file()
    |> File.open([:write], fn file ->
      IO.write(file, average_time)
    end)

    average_time
  end

  defp calculate_average(solution_mod) do
    times =
      solution_mod
      |> file_name()
      |> File.stream!()
      # assuming the file is properly formatted
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list()

    Enum.reduce(times, 0, &+/2) / Enum.count(times)
  end

  defp file_name(solution_mod) do
    File.mkdir("./_benchmarks")

    solution_mod
    |> Atom.to_string()
    |> String.downcase()
    |> (&Path.join("./_benchmarks", &1)).()
  end

  defp average_file(solution_mod) do
    file_name(solution_mod) <> "_average"
  end
end
