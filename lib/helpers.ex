defmodule Helpers do
  @input_dir "inputs/"

  def stream_lines(filename) do
    File.stream!(Path.join(@input_dir, filename))
    |> Stream.map(&String.trim(&1))
    |> Stream.filter(&(String.length(&1) > 0))
  end
end
