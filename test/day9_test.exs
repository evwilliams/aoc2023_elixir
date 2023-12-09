defmodule Day9Test do
  use ExUnit.Case

  test "part1" do
    assert Day9.part1("day9sample.txt") == 114
    assert Day9.part1("day9.txt") == 1_987_402_313
  end

  test "part2" do
    assert Day9.part2("day9sample2.txt") == 5
    assert Day9.part2("day9.txt") == 900
  end
end
