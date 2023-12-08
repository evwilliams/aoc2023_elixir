defmodule Day7Test do
  use ExUnit.Case

  test "part1" do
    assert Day7.part1("day7sample.txt") == 6440
    assert Day7.part1("day7.txt") == 249_638_405
  end

  test "part2" do
    assert Day7.part2("day7sample.txt") == 5905
    assert Day7.part2("day7.txt") == 249_776_650
  end
end
