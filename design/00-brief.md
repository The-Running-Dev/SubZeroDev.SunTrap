# Brief — Deliver Sun Trap from its existing design

## Problem

Sun Trap has a documented product vision, game design, MVP and implementation programme,
and GameEngine `0.5.0` already supplies the supported `world-graph` mechanics it needs. This
repository still contains no executable campaign or client, so none of the game-specific
content, balance, player loop or presentation has been built, played or validated here.

The delivery problem is to turn those existing decisions into a runnable, evidence-backed
game without copying engine-owned behaviour into this repository or allowing client work to
hide an unproven simulation. The
[Implementation Programme](../docs/docs/delivery/implementation-programme.md) is the
execution source of truth; the game documents remain the source of truth for the product.

## Who it is for

This brief is for the maintainers and contributors who will implement, test and deliver Sun
Trap. They must be able to work from a clean checkout and follow the boundary between
engine-owned mechanics and game-owned content without relying on a particular local machine
layout or an unpublished sibling checkout.

The product audience and intended player experience are owned by the
[Vision](../docs/docs/vision/vision.md); this process brief does not redefine them.

## Non-goals

- Reimplementing, forking or locally working around GameEngine core or `world-graph`
  behaviour. A missing mechanical capability is an engine issue.
- Redesigning the game in this process chain or duplicating rules already owned by the
  [game documents](../docs/docs/index.md) or the published engine contracts.
- Building a polished visual client before the headless MVP has been proved through the
  campaign and proving client.
- Expanding the initial delivery beyond the scope excluded by the
  [MVP](../docs/docs/product/mvp.md#4-out-of-scope) and
  [Vision](../docs/docs/vision/vision.md#6-non-goals-for-the-initial-version).
- Settling open product or client choices through implementation convenience; unresolved
  choices remain in the
  [Roadmap, Risks, and Open Questions](../docs/docs/delivery/roadmap-risks-and-open-questions.md).
- Using proprietary names, assets, writing, scenarios, maps, balance or interface expression
  from another resort-management game.

## Definition of done

- A clean checkout installs, builds, typechecks, lints and tests using an immutable public
  GameEngine dependency and no sibling-directory dependency.
- The real Sun Trap MVP campaign loads through the supported engine package surface, and its
  authored content and localization pass positive and deliberately broken-fixture validation.
- A human can start, win, fail, save, load and replay the MVP through a proving client that
  receives projections and validation results rather than implementing game rules.
- Every checkbox in the [MVP definition of done](../docs/docs/product/mvp.md#6-definition-of-done)
  is backed by a named automated test or scripted acceptance run, including deterministic
  serialization, save/load continuation and batch invariance.
- MVP-scale performance and balance are measured; the recorded evidence finds no unresolved
  validation, determinism or replay failure and no known dominant or unwinnable baseline.
- A first visual client satisfies the
  [client acceptance criteria](../docs/docs/product/client-specification.md#11-client-acceptance-criteria)
  and produces the same authoritative result as the proving client for the same inputs.
- The M7–M10 gates in the
  [Implementation Programme](../docs/docs/delivery/implementation-programme.md) are complete
  with their required evidence. This proves the initial product; it does not claim that the
  complete long-term game design has been implemented.

## Environment

- Windows development host with PowerShell Core.
- Node.js 24 and strict TypeScript for the game package and proving client.
- Exact dependency on the public `@the-running-dev/game-engine@0.5.0` package; GameEngine
  never imports Sun Trap.
- Deterministic, single-player simulation that runs locally without a real-time online or
  hosted-service dependency.
- Docusaurus documentation under `docs/`, with authored Markdown under `docs/docs/`.
- Continuous integration must prove the repository from a clean checkout. The renderer and
  visual-client process boundary remain open until their documented decision gate.

## Lifespan

Maintained product. The MVP is the first evidence-producing release of a phased game, not a
throwaway prototype: campaign identity, authored ids, replay compatibility and the
game/engine boundary must be treated as durable. Balance values and presentation technology
remain deliberately revisable until playtesting and the relevant decision gates provide
evidence.
