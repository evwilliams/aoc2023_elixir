defmodule Day11Test do
  use ExUnit.Case

  test "distance" do
    assert Day11.distance({6, 1}, {11, 5}) == 9
  end

  test "part1" do
    assert Day11.part1("day11sample.txt") == 374
    assert Day11.part1("day11.txt") == 10_422_930
  end

  test "part2" do
    assert Day11.solve("day11sample.txt", 10 - 1) == 1030
    assert Day11.solve("day11sample.txt", 100 - 1) == 8410
    assert Day11.part2("day11.txt") == 699_909_023_130
  end
end
