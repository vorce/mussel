defmodule MusselTest do
  use ExUnit.Case

  setup_all do
    write_test_md()
    on_exit fn ->
      delete_test_files
    end
  end

  def write_test_md do
    File.write!(Path.absname("one.md"), "# Hello world")
    File.write!(Path.absname("two.md"), "# Mussel!")
  end

  def delete_test_files do
    File.rm!(Path.absname("one.md"))
    File.rm!(Path.absname("two.md"))
  end

  test "build slides" do
    expected = [{"one.md", "<h1>Hello world</h1>\n<p id=\"next\"><a href=\"two.md.html\">→</a></p>\n"},
                {"two.md", "<h1>Mussel!</h1>\n"}]
    assert Mussel.build(["one.md", "two.md"])
      == expected
  end
end
