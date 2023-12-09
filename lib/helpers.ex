defmodule Helpers do
  @input_dir "inputs/"

  def read_input(filename) do
    File.read!(Path.join(@input_dir, filename))
  end

  def stream_lines(filename) do
    File.stream!(Path.join(@input_dir, filename))
    |> Stream.map(&String.trim(&1))
    |> Stream.filter(&(String.length(&1) > 0))
  end

  def string_after(text, pattern) do
    [_ | [result]] = String.split(text, pattern)
    result
  end

  def split_lines(text) do
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
    Enum.map(Regex.scan(~r'\d+', text), fn [d] -> d end)
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
