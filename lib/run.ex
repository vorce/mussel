defmodule Mix.Tasks.RunMussel do
  use Mix.Task

  @shortdoc "Build presentation from markdown slides. Supply name, template, out directory and slide files as arguments. Ex: runMussel \"my presentation\" mussel.css out one.md two.md three.md"

  def run(args) do
    Mussel.generate(hd(args), Enum.drop(args, 3), Enum.at(args, 1), Enum.at(args, 2))
  end
end
