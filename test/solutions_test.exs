defmodule SoutionsTest do
  @moduledoc false

  use ExUnit.Case

  @mod Solution2

  @csv_path ~s(./sprites/data)

  test "behaves like a solution" do
    # This assumes Solution1 works, refer to solution1_test.exs
    assert @mod.call(@csv_path) == Solution1.call(@csv_path)
  end
end
