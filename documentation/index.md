---
title: 'Sun Trap'
description: 'A satirical resort-management simulation'
sidebar_position: 1
---

# SubZeroDev.SunTrap

**Sun Trap** — a satirical resort-management simulation. Build a holiday paradise, then
discover that people, alcohol, plumbing, weather, queues, staffing and basic geometry have
formed an alliance against you.

> **Status:** design documents only. Nothing here has been built, played or tested — the
> design is unproven in every respect, and [the MVP](/product/mvp/)
> exists to find out which parts of it are wrong. All balance numbers are placeholders.

---

## What This Repository Is

The **game**. It is content and design, built on an engine that lives elsewhere.

```text
SubZeroDev.GameEngine     the deterministic platform
  └── world-graph         the kind — engine-owned contract; implementation pending
        └── Sun Trap      this repository — campaigns, design, client, balance
```

The engine is
[SubZeroDev.GameEngine](https://github.com/The-Running-Dev/SubZeroDev.GameEngine). This
mirrors the relationship
[SubZeroDev.GameOfLife](https://github.com/The-Running-Dev/SubZeroDev.GameOfLife) has with
the `simulation` kind: the kind contract lives in the engine, the game lives here.

## Engine Integration Status

`world-graph` is specified in the engine as a post-MVP kind; its implementation has not
started. Sun Trap therefore remains a design-and-content repository until the engine reaches
that milestone. This repository must track the published contract, not create a local
substitute.

| Authoritative engine resource | Use it for |
|---|---|
| [World-Graph Kind](https://game-engine.subzerodev.com/docs/engine/world-graph-kind) | The kind seam, tick pipeline, actions, determinism, projection, reason codes, events, validation, and game/engine boundary |
| [The Core](https://game-engine.subzerodev.com/docs/engine/core) | The `GameState` envelope, session store, projection boundary, validation, replay, and save rules |
| [Clients](https://game-engine.subzerodev.com/docs/engine/clients) | The client-as-projection rule and API coverage requirements |
| [Content Packs](https://game-engine.subzerodev.com/docs/engine/content-packs) | Pack resolution and campaign-version identity |
| [Engine repository](https://github.com/The-Running-Dev/SubZeroDev.GameEngine) | Current implementation status and the source of the published documentation |

**The engine owns** determinism, seeded randomness, canonical serialization, save and
migration, the content registry, validation, localization, projection, sessions,
achievements, replay, and the API and MCP surfaces. None of it is re-implemented here.

**The kind contract owns** the tick pipeline, guest and staff agents, pathfinding, queues,
construction, the resort economy, incidents and objectives. Its implementation remains an
engine milestone, not a local substitute.

**This repository owns** maps, scenarios, building and product definitions, guest
archetypes, balance, narrative voice, the visual client, and the game's own definition of
done.

## The Engine Contract

The kind this game runs on is specified at
[World-Graph Kind](https://game-engine.subzerodev.com/docs/engine/world-graph-kind) — the
document to read before adding anything here that looks like engine behaviour. Several
things that feel like game decisions are already fixed there:

| Already decided by the engine | Where |
|---|---|
| What may live in game state, and what may not | [§3](https://game-engine.subzerodev.com/docs/engine/world-graph-kind) |
| That a batch of ticks equals the same ticks taken singly | [§5](https://game-engine.subzerodev.com/docs/engine/world-graph-kind) |
| The action list and their parameters | [§6](https://game-engine.subzerodev.com/docs/engine/world-graph-kind) |
| That win and loss are not engine statuses | [§8](https://game-engine.subzerodev.com/docs/engine/world-graph-kind) |
| Integer-only arithmetic, tie-breaking by id, derived entity ids | [§9](https://game-engine.subzerodev.com/docs/engine/world-graph-kind) |
| Reason codes and event names | [§11, §12](https://game-engine.subzerodev.com/docs/engine/world-graph-kind) |
| That content packs merge campaigns wholesale and strings per key | [§14](https://game-engine.subzerodev.com/docs/engine/world-graph-kind) |

The wider engine contract, when a question is not kind-specific:

| Document | Answers |
|---|---|
| [Architecture](https://game-engine.subzerodev.com/docs/engine/architecture) | Every settled decision, including §1a — the test for whether something is a kind or a campaign |
| [The Core](https://game-engine.subzerodev.com/docs/engine/core) | The `GameState` envelope, the Kind seam, the engine API, projection, validation |
| [Clients](https://game-engine.subzerodev.com/docs/engine/clients) | What a client may and may not do, and the coverage checklist that proves it |
| [Content Packs](https://game-engine.subzerodev.com/docs/engine/content-packs) | How packs resolve, and why `campaignVersion` becomes a digest |

## Documentation

The documentation site is published through GitHub Pages at
[the-running-dev.github.io/SubZeroDev.SunTrap](/).
Its authored Markdown and Docusaurus project live in `documentation/`, with the site root
generated from this README. See the
[documentation-site guide](/working-on-it/documentation-site/)
for local checks and deployment behaviour.

Read the game documents in this order:

| Document | Holds |
|---|---|
| [Vision](/vision/) | Why this game exists, what it should feel like, what is out of scope |
| [Game Design](/design/game-design/) | The gameplay: map, guests, buildings, queues, staff, economy, incidents, objectives |
| [Client Specification](/product/client-specification/) | The visual client — what it renders and what it may never do |
| [MVP](/product/mvp/) | The smallest slice that proves the game, and its definition of done |
| [Roadmap, Risks, and Open Questions](/delivery/roadmap-risks-and-open-questions/) | Phases, risks, and what is still undecided |
| [Content and Systems](/design/content-and-systems/) | Field-level detail: guest, building, staff, queue and construction shapes |

## Originality

This game is **inspired by the resort-management genre and reproduces none of it.**
Identity, art, writing, scenarios, building names, maps, balance and UI are original. No
proprietary names, assets, text or expression from any existing title appear in this
repository, and none may be added.
