defmodule Day2 do
  @constraint %{"red" => 12, "green" => 13, "blue" => 14}

  # Shared logic
  def parse_pull(pull) do
    pull
    |> String.split(",")
    |> Stream.map(fn s ->
      [_, count, color] = Regex.run(~r" *(\d+) (red|blue|green) *", s)
      {color, String.to_integer(count)}
    end)
    |> Map.new()
  end

  def parse_game(line) do
    ["Game " <> game_number, pulls_string] = String.split(line, ":")

    pull_stream =
      pulls_string
      |> String.split(";")
      |> Stream.map(&parse_pull/1)

    {game_number, pull_stream}
  end

  # Part 1
  def impossible?(constraint, actual) do
    Enum.any?(actual, fn {k, v} ->
      case Map.fetch(constraint, k) do
        {:ok, constraint_value} when constraint_value >= v -> false
        _ -> true
      end
    end)
  end

  def part1(filename) do
    Helpers.stream_lines(filename)
    |> Stream.map(&parse_game/1)
    |> Stream.map(fn {game_number, pull_stream} ->
      is_impossible =
        pull_stream
        |> Stream.map(&impossible?(@constraint, &1))
        |> Enum.any?()

      if is_impossible, do: 0, else: String.to_integer(game_number)
    end)
    |> Enum.sum()
  end

  # Part 2
  def calculate_power(pull_stream) do
    pull_stream
    |> Enum.reduce(fn pull, fewest_needed ->
      Map.merge(fewest_needed, pull, fn _, v1, v2 -> max(v1, v2) end)
    end)
    |> Enum.reduce(1, fn {_, v}, prod -> prod * v end)
  end

  def part2(filename) do
    Helpers.stream_lines(filename)
    |> Stream.map(&parse_game/1)
    |> Stream.map(fn {_game_number, pull_stream} -> calculate_power(pull_stream) end)
    |> Enum.sum()
  end
end
