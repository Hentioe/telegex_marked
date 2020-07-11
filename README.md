# Telegex.Marked

[![Hex.pm](https://img.shields.io/hexpm/v/telegex_marked.svg)](http://hex.pm/packages/telegex_marked)

Markdown parsing/rendering library customized for Telegram.

## Background introduction

For Telegram bots, sending messages in Markdown format is very dangerous. Because **the implementation of Markdown parsing by the Telegram server is very bad**.

### Like this

Create a link containing `](` in the text:

```elixir
markdown = "[[Google](](https://google.com)"
```

Set `parse_mode` to `Markdown` or `Markdown2`, and send:

```elixir
Telegex.send_message(chat_id, markdown, parse_mode: "MarkdownV2")
```

As a result, there was an accident:

```elixir
{:error,
 %Telegex.Model.Error{
   description: "Bad Request: can't parse entities: Can't find end of TextUrl entity at byte offset 14",
   error_code: 400
 }}
```

You can choose to escape certain characters, but in the face of dynamic text (such as getting the user's name), it is still very dangerous.

## Installation

Add telegex_marked to your `mix.exs` dependencies:

```elixir
def deps do
  [{:telegex_marked, "~> 0.1.0"}]
end
```

Run the `mix deps.get` command to install.

## Features

This library has customized support for `MarkdownV2` to solve these situations. It renders Markdown as HTML, and the HTML is relatively safe.

Not only that, when the wrong Markdown format appears, it can still be parsed as safe HTML. To avoid the failure of sending messages.

All Markdown elements supported (including nesting support):

<pre lang="elixir"><code>
markdown = """
*bold*
_italic_
__underline__
~strikethrough~
*bold _italic bold ~italic bold strikethrough~ __underline italic bold___ bold*
[inline URL](http://www.example.com/)
[inline mention of a user](tg://user?id=123456789)
`inline fixed-width code`
```
pre-formatted fixed-width code block
```
```python
pre-formatted fixed-width code block written in the Python programming language
```
"""
</code></pre>

The converted HTML text:

```elixir
html = """
<b>bold</b>
<i>italic</i>
<u>underline</u>
<s>strikethrough</s>
<b>bold <i>italic bold <s>italic bold strikethrough</s> <u>underline italic bold</u></i> bold</b>
<a href="http://www.example.com/">inline URL</a>
<a href="tg://user?id=123456789">inline mention of a user</a>
<code>inline fixed-width code</code>
<pre>pre-formatted fixed-width code block</pre>
<pre><code class="language-python">pre-formatted fixed-width code block written in the Python programming language</code></pre>
"""
```
Call the `Telegex.Marked.as_html/2` function and test:

```elixir
assert Telegex.Marked.as_html(markdown) == html
```

You only need to convert the Markdown content to HTML before sending, and then specify `parse_mode` as `HTML`.
The general Markdown parser cannot complete this task because the Markdown format supported by Telegram is incomplete and not standard.
