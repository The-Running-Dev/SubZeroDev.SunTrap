# Contributing to Sun Trap

Sun Trap is a game repository, not an engine. Before changing a design document or adding
content, read [`CLAUDE.md`](CLAUDE.md), then follow the numbered documents in
[`README.md`](README.md).

## Boundaries

- Keep engine behaviour in `SubZeroDev.GameEngine`; do not restate or work around the
  `world-graph` contract here.
- Keep all game identity original. Do not add proprietary names, assets, writing, maps, UI,
  or other expression from existing games.
- Use integer or fixed-point balance values only. Do not introduce floating-point values
  into authoritative game state.

## Document changes

- Preserve the numbered-document order. Append a new document where possible; use a letter
  suffix if a document must sit between two existing ones.
- Update every affected cross-reference when headings or filenames change.
- Treat balance figures as provisional content, not engine rules.
- Present significant design decisions for approval before batching related edits.

## Before opening a change

- Check Markdown renders as intended and has no trailing whitespace.
- Verify factual claims against the engine's published documentation.
- If implementation exists, add tests appropriate to the changed behaviour.
