defmodule Day1 do
  @input_dir "inputs/"
  @digit "[[:digit:]]"
  @mapping %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
    "zero" => 0
  }

  # Shared Logic
  def process(filename, fun) do
    File.stream!(Path.join(@input_dir, filename))
    |> Stream.map(&String.trim(&1))
    |> Stream.filter(&(String.length(&1) > 0))
    |> Stream.map(fun)
    |> Enum.sum()
  end

  def solve(filename, forward_pattern, reverse_pattern) do
    fun = fn line ->
      first = run_on_match(forward_pattern, line, &Map.get(@mapping, &1, &1))
      last = run_on_match(reverse_pattern, reverse(line), &Map.get(@mapping, reverse(&1), &1))
      joined_int([first, last])
    end

    process(filename, fun)
  end

  def run_on_match(pattern, string, fun) do
    [match] = Regex.run(pattern, string)
    fun.(match)
  end

  def reverse(string), do: String.reverse(string)
  def joined_int(pair), do: String.to_integer(Enum.join(pair, ""))

  # Part 1 Entrypoint
  def part1(filename) do
    pattern = Regex.compile!(@digit)
    solve(filename, pattern, pattern)
  end

  # Part 2 Entrypoint
  def part2(filename) do
    text_pattern = Enum.join(Map.keys(@mapping), "|")
    forward_pattern = Regex.compile!(@digit <> "|" <> text_pattern)
    reverse_pattern = Regex.compile!(@digit <> "|" <> reverse(text_pattern))

    solve(filename, forward_pattern, reverse_pattern)
  end
end
