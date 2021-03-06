defmodule ExParse.PosInfo do
  @moduledoc """
  Provides some datatype and functions over it that let you determine position
  in a file.
  """

  defstruct file: "", line: 0, char: 0..0
  @opaque t :: %__MODULE__{file: String.t,
                           line: non_neg_integer,
                           char: Range.t(non_neg_integer, non_neg_integer)}

  @doc """
  Creates a new `PosInfo`.

  `file` is the name of the file the `PosInfo` is for, `line` the line the info
  is for and `char` specifies starting and ending character on that line.
  """
  def new(file \\ "", line \\ 0, char \\ 0..0)
  def new(file, line, char) do
    cond do
      Range.range?(char) -> %__MODULE__{file: file, line: line, char: char}
      is_integer(char)   -> %__MODULE__{file: file, line: line,
                                        char: Range.new(char, char)}
      true               -> raise ArgumentError,
                                  message: "Expected Argument to be either a range or an integer, but got -> #{inspect char} <-"
    end
  end

  @doc """
  Advances the position info to the beginning of the next line.

  `pi` is the PosInfo you want to modify.

  Returns the modified `PosInfo`.
  """
  def next_line(%__MODULE__{line: line} = pi) when line >= 0 do
    %{pi | line: line + 1, char: 0..0}
  end
end

defimpl Inspect, for: ExParse.PosInfo do
  import Inspect.Algebra

  def inspect(posinfo, opts) do
    concat ["%ExParse.PosInfo{",
            "file: ", to_doc(posinfo.file, opts), ", ",
            "line: ", to_doc(posinfo.line, opts), ", ",
            "char: ", to_doc(posinfo.char, opts),
            "}"]
  end
end
