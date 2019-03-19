defmodule Soution1Test do
  @moduledoc false

  use ExUnit.Case

  @csv_path ~s(./sprites/data)

  test "returns the correct result for data" do
    assert Solution1.call(@csv_path) == [
      {"bulbasaur", 1}, {"charmander", 1}, {"ivysaur", 1}, {"squirtle", 1},
      {"venusaur", 1}
    ]
  end
end
