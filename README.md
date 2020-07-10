# Telegex.Marked

Markdown parsing/rendering library customized for Telegram.

## Background introduction

For Telegram robots, sending messages in Markdown format is very dangerous. Because **the interpretation of Markdown by the Telegram server is very bad**.

### Like this

Create a link containing `](` in the text:

```elixir
iex>markdown = "[[Google](](https://google.com)"
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

## Features

This library has customized support for `MarkdownV2` to solve these situations. It renders Markdown as HTML, and the HTML is relatively safe.

Not only that, when the wrong Markdown format appears, it can still be parsed as safe HTML. To avoid the failure of sending messages.

    markdown """
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

    html """
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

    Telegex.Marked.as_html(markdown) == html # => true

You only need to convert the Markdown content to HTML before sending, and then specify `parse_mode` as `HTML`.
The general Markdown parser cannot complete this task because the Markdown format supported by Telegram is incomplete and not standard.
