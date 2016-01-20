defmodule ExParse.PosInfo do
  defstruct file: "", line: 0, char: 0..0
  @opaque t :: %__MODULE__{file: String.t,
                           line: non_neg_integer,
                           char: Range.t(non_neg_integer, non_neg_integer)}

  def new(file \\ "", line \\ 0, char \\ 0..0)
  def new(file, line, char) do
    cond do
      Range.range?(char) -> %__MODULE__{file: file, line: line, char: char}
      is_integer(char) -> %__MODULE__{file: file, line: line, char: Range.new(char, char)}
    end
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