marked_markdown = """
normal1*bold1*normal2*blod2*normal3
*bold __underline__ bold*
*bold _italic bold ~italic bold strikethrough~ __underline italic bold___ bold*
[inline URL](http://www.example.com/)
[inline mention of a user](tg://user?id=123456789)
`inline fixed-width code`
"""

earmark_markdown = """
normal1**bold1**normal2**blod2**normal3
**bold __underline__ bold**
**bold _italic bold ~~italic bold strikethrough~~ __underline italic bold___ bold**
[inline URL](http://www.example.com/)
[inline mention of a user](tg://user?id=123456789)
`inline fixed-width code`
"""

marked_fun = fn ->
  Telegex.Marked.InlineParser.parse(marked_markdown) |> Telegex.Marked.HTMLRenderer.render()
end

earmark_run = fn ->
  Earmark.as_html(earmark_markdown)
end

Benchee.run(%{
  "Marked" => marked_fun,
  "Earmark" => earmark_run
})
