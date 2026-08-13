---
sidebar_label: Content Authoring
---

# Sun Trap Content Authoring Guide

Sun Trap supplies campaign data to GameEngine's `world-graph` kind. The engine owns the
runtime model, action semantics, validation, determinism, serialization and projection. This
repository owns the values that make a particular beach worth managing: maps, definitions,
balance, localization and scenarios.

The authoritative source contract is
[`WorldGraphCampaignSource`](https://game-engine.subzerodev.com/docs/engine/world-graph-kind).
Import that contract from `@the-running-dev/game-engine`; do not copy its interfaces into
this repository. A content change is valid only when it builds through
`buildWorldGraphCampaign`, then `buildCampaign`.

## 1. Catalog ownership

Keep authored values in catalog-focused modules and assemble them in one campaign module.

| Catalog | Owns |
|---|---|
| `map` | terrain, grid dimensions, spawn and exit positions |
| `meters` | guest needs and opinions |
| `products-buildings` | products, buildings, costs, capacities and service effects |
| `guests-staff` | guest archetypes, staff roles and incident definitions |
| `scenario` | clock, starting position, spawning, objective and failures |
| `campaign` | the source assembly and its localization table |

Catalog files are content only. They do not implement actions, calculate paths, generate
entity ids, mutate engine state or recreate a validation rule. If a desired behaviour has no
place in `WorldGraphCampaignSource`, it is an engine request rather than a local workaround.

## 2. Stable authored identity

All Sun Trap authored ids are local kebab-case identifiers. Runtime entity ids are always
engine-derived and must never be authored as content ids.

The MVP's stable identifiers are:

| Catalog | IDs |
|---|---|
| map and scenario | `breakwater-beach`, `opening-day` |
| needs and opinion | `thirst`, `toilet`, `price` |
| products | `soft-drink`, `toilet-visit` |
| buildings | `drink-stand`, `toilet`, `waste-point` |
| guest, staff and incident | `day-tripper`, `cleaner`, `litter` |
| objective | `opening-target` |
| failures | `bankrupt`, `sanitation-collapse`, `deadline-missed` |

The campaign id is `sun-trap-mvp`. Its campaign version is `0.1.0`; versioning the package
does not replace campaign-version identity.

## 3. Localization and voice

Every definition has original deadpan display text. Localization keys are namespaced as
`sun-trap-mvp.<id>.<field>`, including the campaign title. The content test suite checks that
keys are present and unique; never rely on a UI fallback for a missing key.

The voice is seaside optimism with a straight face: an amenity can be cheerful, its warning
can be grim, and neither should imitate a real resort-management game's writing.

## 4. MVP balance, deliberately provisional

The opening-day package fixes these first-pass values so its tests and future balance work
have one reproducible starting point.

| Area | MVP value |
|---|---|
| clock | 10-second ticks; `ticksPerDay = 8,640`; `maxTicksPerAction = 360` |
| map | 12 × 8 all-sand beach, west-edge spawn and east-edge exit |
| starting cash | 250,000 cents |
| construction | drink stand 100,000; toilet 50,000; waste point 10,000 cents |
| staffing | cleaner hire 20,000 cents; wage 50,000 cents per day |
| drink | cost 150 cents; default price 500 cents |
| guests | spawn each 30 ticks; cap 20; stay 720 ticks |
| objective | 100,000 cents lifetime revenue and average cleanliness at least 50 before Day 2 |
| failures | bankruptcy after one tick below zero; sanitation collapse after 360 ticks at zero cleanliness; deadline at 17,280 ticks |

These are game balance values, not additions to the engine contract. M9 is responsible for
proving or revising them without changing the stable ids above.

## 5. MVP simplifications

The first campaign deliberately uses rotation `0` only, immediate construction, unlimited
inventory and no utilities. Cleaner dispatch is global. Drink-stand service is implicit in
the building rather than represented by a service-worker agent. There are no guest groups,
staff shifts or fatigue. Bankruptcy is immediate once the one-tick condition is met. The
opening theme is a budget-beach soft opening: just enough shade to sell, just enough plumbing
to argue about.

## 6. Authoring and verification rules

- Use integer content values only; fixed-point units and condition operators come from the
  engine contract.
- Keep map coordinates, footprint rotations, product references, meter references and
  localization keys internally consistent before calling the builder.
- Let the engine return its validation reason for invalid placement. A client or test may
  assert that reason, but may not recreate placement geometry.
- Test a real package-root import through registry construction and `createGame`.
- Test deterministic serialization using the same seed and actions, and test that preview
  leaves state unchanged.
- Keep broken fixtures independent: one missing reference, one missing localization entry and
  one invalid numeric range per fixture.

## 7. Known engine follow-up

The documented MVP can start on GameEngine `0.5.0`. Timed construction, a building lifecycle,
alerts, complete cleanliness and wear, and spontaneous incident rolls remain non-blocking
post-MVP engine gaps. They block a claim that the complete Sun Trap design is implemented;
they do not justify duplicating engine behaviour in campaign data.
