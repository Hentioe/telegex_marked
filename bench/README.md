# Bench

Benchmark comparison between telegex_marked and other mainstream Markdown parsing/rendering libraries.

## Run

```bash
mix bench.as_html
```

## Current status

The current telegex_marked performance is relatively weak, and there is still much room for optimization.
Compared to performance, the current focus is on security (that is, ensuring that messages can be accepted by Telegram servers).

Around 0.1.0, the focus will be on performance optimization. As close as possible to Earmark.
