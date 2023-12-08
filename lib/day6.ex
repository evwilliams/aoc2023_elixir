defmodule Day6 do
  def calc_options(time) do
    1..time
    |> Stream.map(fn t_hold ->
      t_hold * (time - t_hold)
    end)
  end

  def part1(filename) do
    Helpers.stream_lines(filename)
    |> Stream.map(&Helpers.ints/1)
    |> Stream.zip()
    |> Stream.map(fn {time, distance} ->
      calc_options(time)
      |> Stream.filter(&(&1 > distance))
      |> Enum.count()
    end)
    |> Enum.product()
  end

  def part2(filename) do
    [time, distance] =
      Helpers.stream_lines(filename)
      |> Stream.map(&Helpers.string_after(&1, ":"))
      |> Stream.map(&Helpers.remove_whitespace/1)
      |> Enum.map(&String.to_integer/1)

    [{time, distance}]
    |> Stream.map(fn {time, distance} ->
      calc_options(time)
      |> Stream.filter(&(&1 > distance))
      |> Enum.count()
    end)
    |> Enum.product()
  end
end
