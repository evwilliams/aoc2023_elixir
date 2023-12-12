defmodule Helpers do
  @input_dir "inputs/"

  def read_input(filename) do
    File.read!(Path.join(@input_dir, filename))
  end

  def read_input(filename, of: fun) do
    fun.(read_input(filename))
  end

  def write_output(filename, content) do
    File.write(Path.join(@input_dir, filename), content)
  end

  def stream_lines(filename) do
    File.stream!(Path.join(@input_dir, filename))
    |> Stream.map(&String.trim(&1))
    |> Stream.filter(&(String.length(&1) > 0))
  end

  def stream_lines(filename, of: fun) do
    Stream.map(stream_lines(filename), fun)
  end

  def character_grid(lines) do
    Enum.with_index(lines)
    |> Enum.flat_map(fn {line, row} ->
      String.graphemes(line)
      |> Enum.with_index(fn char, col -> {{row, col}, char} end)
    end)
    |> Map.new()
  end

  def string_after(text, pattern) do
    [_ | [result]] = String.split(text, pattern)
    result
  end

  def lines(text) do
    Regex.split(~r'\n+', text, trim: true)
  end

  def nested_map(outer_enum, fun) do
    Enum.map(outer_enum, fn x -> Enum.map(x, fun) end)
  end

  def whitespace_split(text) do
    Regex.split(~r'\s+', text, trim: true)
  end

  def remove_whitespace(text) do
    String.replace(text, ~r'\s+', "")
  end

  def digits(text) do
    Enum.map(Regex.scan(~r'\-?\d+', text), fn [d] -> d end)
  end

  def ints(text) do
    Enum.map(digits(text), &String.to_integer/1)
  end

  def paragraphs(text) do
    Regex.split(~r'\n\n', text, trim: true)
  end

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, Integer.gcd(a, b))
end
