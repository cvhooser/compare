defmodule Compare.CLI do
  @moduledoc """
  Documentation for Diff.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Diff.hello
      :world

  """

  def main(argv) do
    args = OptionParser.parse(argv,
      switches: [path: :string, diff: :string],
      aliases: [p: :path, d: :diff])

    file_path =
      case Keyword.fetch(elem(args, 0), :path) do
        {:ok, val} ->
           val
        _ ->
          raise "Please specify a path to the files."
      end

    files = elem(args, 1)
    cond do
      length(files) < 2 ->
        raise "Not enough files provided, supply two files."
      length(files) > 2 ->
        raise "Please specify two files only: -p or --path"
      true ->
        Enum.map(files, & file_path <> &1) |> parse_json
    end

  end

  defp parse_json(file_names) do
    jsons = Enum.map(file_names, fn file_name -> File.read!(file_name)
        |> (&~s/#{&1}/).()
        |> Poison.Parser.parse!
      end)

    print(List.first(jsons), List.last(jsons))
  end

  defp print(map1, map2) do
    IO.inspect map1
    IO.inspect map2
  end

end
