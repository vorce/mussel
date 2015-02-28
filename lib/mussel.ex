defmodule Mussel do
  def build(slides) when is_list(slides) do
    slides
    |> Enum.chunk(2, 1, [])
    |> Enum.map(fn(ls) -> {(hd ls), file_content(ls)} end)
    |> Enum.map(fn({file, md}) -> {file, md_to_html(md)} end)
  end

  def generate(name \\ "Mussel", slides, template \\ "mussel.css", out \\ "out") when is_list(slides) do
    File.mkdir!(Path.absname(out))
    slides
    |> build
    |> Enum.map(fn({file, html}) ->
        {file, html_start(name, file, template) <> html <> html_end()}
      end)
    |> Enum.each(fn({file, html}) ->
        html_to_file(Path.absname(out <> "/" <> file <> ".html"), html)
      end)
    File.cp_r!("templates", out)
    File.cp_r!("js", out)
  end

  def html_start(name, file, template) do
    "<!DOCTYPE HTML>\n" <>
    "<html>\n" <>
    "  <head><title>" <> name <> ": " <> file <> "</title>\n" <>
    "  <meta charset=\"UTF-8\">\n" <>
    "    <link rel=\"stylesheet\" href=\"" <> template <> "\">\n" <>
    "    <script src=\"jquery-2.1.3.min.js\"></script>\n" <>
    "    <script src=\"mussel.js\"></script>\n" <>
    "  </head>\n" <>
    "<body>\n" <>
    "<div class=\"mussel\">\n"
  end

  def html_end do
    "</div>\n" <>
    "<script>$(document).keyup(function(event) { \n" <>
    "  if(event.which == 70) { // F keycode\n" <>
    #"    launchFullscreen(document.documentElement);\n" <>
    "  } else if(event.which == 39) { // Right arrow\n" <>
    #"    var fs = isFullscreened();\n" <>
    "    var next = $(\"#next > a:first-child\").attr(\"href\");\n" <>
    "    window.location = next;\n" <>
    #"    if(fs) { launchFullscreen(document.documentElement); }\n" <>
    "  } else if(event.which == 37) { // Left arrow\n" <>
    "    history.back();\n" <>
    "  }\n" <>
    "});\n" <>
    "</script>\n" <>
    "</body>\n" <>
    "</html>\n"
  end

  def file_content([file]) do
    file_to_text(file)
  end
  def file_content([file, next]) do
    file_to_text(file) |> create_link(next)
  end

  def create_link(source, to) do
    source <> "\n\n[→](" <> to <> ".html)\n{: #next}" 
  end

  def file_to_text(file) do
    iod = File.open!(Path.absname(file), [:read, :utf8])
    txt = IO.read(iod, :all)
    File.close(iod)
    txt
  end

  def md_to_html(md) do
    Earmark.to_html(md)
  end

  def html_to_file(name, html) do
    iod = File.open!(name, [:write, :utf8])
    IO.write(iod, html)
    File.close(iod)
  end
end
