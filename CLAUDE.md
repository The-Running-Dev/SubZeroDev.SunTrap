# Project Instructions

## What This Project Is

**Sun Trap — the game.** A satirical resort-management simulation: its **design** and,
later, its **content and client**. It is *not* an engine. It runs on the `world-graph` kind
in a platform that lives in another repository.

```text
SubZeroDev.GameEngine     the deterministic platform — another repository
  └── world-graph         the kind — contract complete; implementation pending
        └── Sun Trap      this repository — campaigns, design, client, balance
```

**Companions:**
- **Engine** — [SubZeroDev.GameEngine](https://github.com/The-Running-Dev/SubZeroDev.GameEngine):
  the core, the kinds, the contracts. Published specs at
  <https://game-engine.subzerodev.com/docs/>.
- **Sibling game** — [SubZeroDev.GameOfLife](https://github.com/The-Running-Dev/SubZeroDev.GameOfLife):
  Life in the Fast Lane, on the `simulation` kind. Same relationship to the engine that this
  repository has. When unsure how a game repo should relate to the engine, look there.
- **Hosting / NEaaS** — [SubZeroDev.Platform](https://github.com/The-Running-Dev/SubZeroDev.Platform):
  deferred, and not this project's concern.

**Current implementation status:** the engine's shared MVP is built and tested. The
`world-graph` kind and a supported companion-package surface are not yet built. Track their
gated work, and all Sun Trap work that follows it, in
[`docs/docs/delivery/implementation-programme.md`](docs/docs/delivery/implementation-programme.md).

## The Boundary — Read This Before Anything Else

**Most of what feels like a game decision here has already been decided by the engine, and
those decisions are not re-openable in this repository.** The single most likely failure
mode in this repo is re-specifying something the engine owns, in slightly different words,
and creating a contradiction nobody notices until implementation.

The kind contract is
[World-Graph Kind](https://game-engine.subzerodev.com/docs/engine/world-graph-kind). Read it
before writing anything that describes behaviour rather than content.

| The engine decides | Do not re-specify here |
|---|---|
| What may live in game state | No `version`, `gameId`, `seed`, `status`, `metadata`, action log, or persisted RNG state in any shape this repo defines |
| The action list and parameters | `build`, `demolish`, `hire_staff`, `fire_staff`, `assign_staff`, `set_price`, `open_building`, `close_building`, `dismiss_alert`, `advance_ticks` — that is the set |
| Determinism | Integers only, ties break by entity id, canonical iteration order, engine-derived entity ids, no `Math.sqrt` in distance, no serialized caches |
| Batch invariance | A batch of ticks reaches the same world as the same ticks taken singly. Presentation speed is never a game input |
| Win and loss | Not engine statuses. The envelope has exactly three — `active`, `ended`, `abandoned` — and win/loss is terminal identity, published ids only |
| Reason codes and event names | Defined in the kind contract. A new one is an engine change, not a content change |
| Content pack merging | Campaigns replace wholesale, strings replace per key |
| The client contract | A client is a projection of the session store, never a participant |

**If something here needs the engine to change, that is an engine issue in the engine
repository — not a paragraph here describing different behaviour.** Say so explicitly and
stop; do not work around it locally.

## What This Repository Owns

Maps, scenarios, building and product definitions, guest archetypes, balance numbers,
narrative voice, the visual client, the balance harness, and this game's own definition of
done.

## The Documentation

Read in order. The installer-managed Docusaurus project is `docs/`; authored Markdown lives
under `docs/docs/`. `docs/src/pages/index.md` is generated from `README.md` and must never be
hand-edited. It renders the README-derived public home at `/`. `docs/docs/index.md` is the
separately authored landing page for the `/docs/` section.

| File | Holds |
|---|---|
| `README.md` | What this is, its relationship to the engine, the originality boundary |
| `docs/docs/vision/vision.md` | Why the game exists, what it should feel like, what is out of scope |
| `docs/docs/design/game-design.md` | Gameplay: map, guests, buildings, queues, staff, economy, incidents, objectives |
| `docs/docs/product/client-specification.md` | The visual client — what it renders, and what it may never do |
| `docs/docs/product/mvp.md` | The smallest slice that proves the game, and its definition of done |
| `docs/docs/delivery/implementation-programme.md` | The checkable cross-repository implementation plan and milestone gates |
| `docs/docs/delivery/roadmap-risks-and-open-questions.md` | Phases, risks, what is undecided, and §5 — what the engine has already closed |
| `docs/docs/design/content-and-systems.md` | Field-level shapes: guest, building, staff, queue, construction. `kindState` internals |

**Reading order is explicit.** `docs/sidebar.ts` groups the site into Orientation,
Game Design, Product, Delivery, and Working on It; folders provide source organization only.
Add each page to the appropriate category in that sidebar, preserve the conceptual reading
order shown above, and rewrite every affected cross-link when a page moves or changes heading.

### Documentation Site Rules

- `docs/` is the installer-managed Docusaurus project; authored Markdown belongs under
  `docs/docs/`. Do not recreate a parallel `documentation/` project.
- `docs/src/pages/index.md` is generated from `README.md` by
  `build/ConvertTo-DocumentationHomepage.ps1`; regenerate it after editing the README.
  `docs/docs/index.md` is the authored `/docs/` landing page.
- The README-derived home is served at `/`; the documentation sidebar is served below
  `/docs/`. Keep redirects for retired root-level documentation routes.
- Run `./build/Test-Documentation.ps1` and a production documentation build before opening a
  documentation PR. GitHub Actions repeats both checks, then deploys on `main`.
- The documentation template is pinned by manifest digest in both workflows,
  `docs/Dockerfile`, and `docs.ps1`. Update all four together only after reviewing the
  desired image's digest with `docker manifest inspect --verbose`.
- Use relative Markdown links only for files inside this repository. The engine is external:
  link its published documentation, never a relative traversal into its checkout.

### Where Drift Will Happen

**Content and Systems ↔ the engine's kind contract.** The Content and Systems document defines shapes that must obey
rules stated in the engine. Its §1 restates those rules deliberately, as a checklist — when
the engine's contract changes, §1 is the first thing to reconcile, and every shape below it
the second.

**Envelope duplication.** The engine names this as its own recurring defect and it has been
caught five times there. It arrives here as: adding a field to a shape in `06` that the
engine already owns. Before adding any field, ask whether the envelope, the campaign, or the
registry already holds it.

**Counts drifting from what they count.** "All eight operations", "the two kinds", "six of
the eight" — every one of those was wrong at some point in the engine repo, and each survived
multiple review passes. When a document states a number, check it against the list it counts,
not against memory.

**Balance numbers leaking into contracts.** Tick duration, utility weights, price elasticity
are *balance*, revisited every playtest. They belong in content, never in a sentence that
reads like a rule.

## Working Conventions

Findings and review items are presented **one at a time for sign-off**, not applied in bulk.
When a suggestion is declined, record it in the affected document (or the Roadmap, Risks,
and Open Questions document's §4) as a known-and-retained issue rather than
dropping it silently.

**Verify, don't assert.** Check claims against the artefact — the engine's published spec,
the actual file, the real output — not against what you remember writing.

**Design before content, content before client.** The engine's own order is spec → tests →
plain client → UI, and it exists because building ahead of the contract is where drift
starts.

## Originality

This game is **inspired by the resort-management genre and reproduces none of it.** Identity,
art, writing, scenarios, building names, maps, balance and UI are original. No proprietary
names, assets, text or expression from any existing title may appear in this repository. This
is not a stylistic preference — treat it as a hard constraint on every asset and every line of
content.

Lessons learned the hard way live in [`agent.md`](agent.md).
