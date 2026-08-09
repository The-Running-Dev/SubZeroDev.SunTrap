# Project Instructions

## What This Project Is

**Sun Trap — the game.** A satirical resort-management simulation: its **design** and,
later, its **content and client**. It is *not* an engine. It runs on the `world-graph` kind
in a platform that lives in another repository.

```text
SubZeroDev.GameEngine     the deterministic platform — another repository
  └── world-graph         the kind — implemented in GameEngine 0.5.0
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

**Current implementation status:** the engine's shared MVP and `world-graph` kind are built
and tested, and the supported public package `@the-running-dev/game-engine@0.5.0` includes
the kind and its campaign interfaces. Sun Trap has not yet pinned that dependency or added
executable campaign content. The engine work in M2–M6 still requires a task-by-task evidence
audit before its programme boxes are checked; track that reconciliation and all local work in
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

## Process Documentation (`design/`)

Everything above this point is about **Sun Trap the game** — what it is and where its
content lives. Everything below is the **agent working contract**: how any session, on any
task in this repository, should operate. `design/` at the repository root is a separate,
process-only document set — a brief, a contract, slice plans and a decision log for changes
to *this repository itself* (tooling, build scripts, the documentation site, or process). It
is distinct from `docs/docs/design/` and the rest of `docs/docs/`, which is the game's own
domain content and stays governed by the reading order above.

### Source of truth

The design docs outrank the code. In precedence order:

1. `design/00-brief.md` — problem, non-goals, definition of done
2. `design/20-contract.md` — types, schemas, signatures, error semantics
3. `design/10-design.md` — architecture, data model, failure modes
4. `design/30-slices.md` — work breakdown and acceptance criteria
5. `design/90-decisions.md` — append-only decision log

If the code contradicts the contract, that is a defect in one of them. **Stop and say which
one you think is wrong. Do not silently reconcile.**

### Safe start

Before editing anything:

```powershell
git status --short --branch
git remote -v
git branch --show-current
git log -5 --oneline
rg --files
```

- Discover files and tooling rather than assuming they exist.
- Read this file and the sources you are about to change **completely**. Editing from
  memory, or from a diff, is the most common cause of drift.
- Preserve unrelated and uncommitted work. Never stage, reset, clean, or overwrite it.
- Work on a focused branch.
- Where guidance conflicts, follow the most specific applicable instruction.

## Model, Effort, and Review Budget

**Model choice follows task complexity. The command being invoked does not determine the
model.** Budget scales with **complexity, not size** — a one-line change to an invariant is
architectural; a 500-line transcription against a settled contract is not.

Name model *families*, never pinned versions. Version identifiers churn; family aliases do
not.

| Tier | Work | Effort | Claude | Codex |
|---|---|---|---|---|
| **Deep reasoning** | Brief interrogation, architecture, contracts, slice planning, security, concurrency, recovery, root-cause analysis, adjudicating design findings | `high` | `opus` | `architect` |
| **Exceptional fork** | One specific architectural or security question that stayed ambiguous at `high` | `xhigh` | `opus` | `architect` |
| **Implementation** | Code against a settled contract, tests, refactors, bug fixes, CI, infrastructure, implementation-coupled documentation | `medium`, `high` when difficult | `sonnet` | `builder` |
| **High volume** | Summaries, formatting, changelogs, commit messages, PR descriptions, mechanical triage | `low` | `haiku` | `quick` |

- **Never use `max` effort unless explicitly asked for it by name.**
- **`xhigh` is for one question, not one pipeline.** Running a whole design phase at `xhigh`
  is not rigour, it is a substitute for asking a precise question.
- **Escalate rather than guess.** A high-volume task that raises an implementation question
  becomes implementation tier; an implementation task that raises an architectural question
  becomes deep reasoning. **Do not keep implementing while that uncertainty is unresolved.**
- **Say so when the session is under-powered.** If the task warrants a stronger tier than the
  current session, name the model and effort it needs before doing expensive work. If the
  session is *stronger* than required, just proceed — do not interrupt to say so.

**Division of control.** The session owner sets the session model. An agent sets subagent
models and scales its own reasoning depth, but cannot change its own session model.

### Command routing

| Command | Tier | Notes |
|---|---|---|
| `/brief-check`, `/design`, `/contract`, `/slices` | `opus`, `high` | — |
| `/redteam` | strongest model, **different vendor from the design author** | If it must be Claude, a fresh `opus`, `high` session |
| `/slice` | `sonnet`, `medium` | `high` for a large or difficult slice |
| `/reconcile` | `opus`, `high` to decide which side of a drift is correct | `sonnet`, `medium` for the mechanical edits once that is decided |
| `/make-human-docs` | `sonnet`, `medium` | Escalate only if the design turns out to be ambiguous — then stop, do not resolve it in prose |
| `/track` | `sonnet`, `medium` | Mechanical sync; escalate only to judge whether a drifted slice is a design change |
| `/verify` | `sonnet`, `medium` | Escalate to deep reasoning only to diagnose a failure, never to run the gates |
| `/pr` | `sonnet`, `medium` | — |
| `/resolve` | `sonnet`, `medium` | Escalate to judge a contested finding, not to triage the obvious ones |
| `/refine` | `sonnet`, `medium` | Never escalates — an architectural ask is routed to the command that owns it, not refined |
| `/install` | `sonnet`, `medium` | — |
| `/install-all` | `sonnet`, `medium` | Escalate only to judge whether a per-repo hard stop is actually safe to resolve — never to resolve it unattended |
| `/kit-help` | `haiku`, `low` | Orientation from file existence and a tracker listing. Escalate only where the repository's state matches no stage |

**Never recommend re-running a phase gate.** The person is the one who decides when a phase
repeats. This holds outside `/redteam` too — see that command for its own stopping rule.

### Session boundaries

Routing says which model runs a command. This says **when a session must end.** A boundary
exists wherever carrying context would corrupt the next step's judgement, or wherever the
next step must read the tree rather than remember it. **The artifact is the handoff, not the
conversation** — a stage that writes one has already handed over everything the next stage is
entitled to.

| Boundary | Rule | Why |
|---|---|---|
| `/design` → `/redteam` | **Fresh session, and a different vendor.** | A model recognises its own output distribution and defends it. Fresh context on the same model is already the weak form; the same session is not a review at all. |
| Any stage that writes an artifact → the next | Fresh. | The next stage's input is the committed file. A session that also remembers the arguments behind it will design against the arguments. |
| `/slices` → `/slice` | Fresh, and **one slice per session**. | A slice that does not fit one session without compaction is too large — that is a `/slices` defect, so say so rather than pressing on. |
| `/slice` → `/verify` → `/pr` → `/resolve` | **Same session.** | These act on the branch and worktree the slice just produced, and `/pr` must carry `/verify`'s did-not-run list into the description **verbatim**. A fresh session would restate it from a summary, which is the fabricated gate result *Verification* exists to prevent. |
| merge → `/track` | Fresh. | `/track` reads the tracker and `design/` as they now stand. The session that just implemented the slice holds an opinion about whether it is done, and doneness is a human mark, not an agent's. |
| implementation → `/reconcile` | Fresh. | It compares the tree against the docs. The session that wrote the code carries what it *intended* to write, which is the one thing the comparison must not be given. |

**Compaction is a boundary that was not chosen.** If a session compacts mid-slice, report
it — the slice was mis-sized, and the work after the compaction was done against a summary of
the contract rather than the contract.

### Budget discipline

- **Do not spend reasoning to manufacture findings, alternatives, or open questions.** A
  short honest answer beats a padded one; "none at this level" is a valid result.
- **Once a policy decision is signed off and recorded, do not relitigate it** without new
  evidence. Name the evidence if there is some.
- **Spend frontier-model reasoning on decisions that are expensive to reverse**, not on
  producing more prose.

### What should stop being model work

Routing decides *which* model does a job. This decides whether a model should be doing it at
all.

| | Work | Where it belongs |
|---|---|---|
| 🟢 **Necessary** | Architecture, contracts, root-cause analysis, design tradeoffs, adjudicating findings | A model, at the tier above |
| 🟡 **Maybe avoidable** | Regenerating context already established, duplicate repository scans, rewriting boilerplate | A model, but the repetition is a signal — say so |
| 🔴 **Definitely avoidable** | Formatting, mechanical text transformation, arithmetic over files, counting, collecting metrics | Code. It should leave the model entirely |

**A red item is a defect in the tooling, not in the run.** Noticing one is worth a line;
performing it repeatedly and never saying so is the failure. When a red item recurs, put it
in `## Open` in `design/90-decisions.md` so `/track` can turn it into an issue — that is the
existing path, and there is no separate mechanism for this.

Two distinctions that are easy to get wrong:

- **The mechanical half of a task is red; the judgement half is not.** Opening an issue is an
  API call, but deciding what warrants one is not. Do not classify a whole command by its
  cheapest step.
- **Do not report a cost you did not measure.** A model is not given its own token counts or
  elapsed time, so any figure it states about its own run is an estimate presented as a
  measurement. `tools/Measure-Session.ps1` reads the real per-call usage from the session
  transcript. Use it, or say nothing.

## Hard Rules

- **Non-goals are binding.** Anything listed as a non-goal in `design/00-brief.md` is out of
  scope even if it looks trivial, even if the file already being touched.
- **One slice at a time.** Do not start slice N+1 because something was noticed while doing
  slice N. Write it to `design/90-decisions.md` under `## Open` instead.
- **No new dependencies** without a decision-log entry naming the alternatives rejected and
  why.
- **No new public interfaces** that are not in `design/20-contract.md`. If one is needed,
  stop and ask for a contract amendment.
- **Ask instead of assuming.** If two readings of a spec are both defensible, stop and
  present both. Do not pick one and proceed.
- **Every slice ends runnable.** No half-wired states committed.

## Single Ownership

- **Reference, never restate.** A rule that lives in another document is linked, not copied.
  Two copies of a rule is a promise they will diverge and a guarantee nobody notices which is
  stale.
- **Move, never copy.** A rule has exactly one home. When it belongs somewhere else, move it
  and leave a reference behind.
- If a document genuinely must repeat something to stand on its own, name the canonical copy
  in the text and change both in the same commit. Naming a canonical copy is what makes the
  others checkable.
- **The test for where a decision belongs:** would a second consumer face this same question?
  If yes it belongs in the shared document, even while only one consumer exercises it. Where
  it is genuinely unclear, the shared document is the safer home — a rule that turns out to be
  specific is easy to relax later; a rule discovered to be shared after three consumers each
  answered it differently is a migration.

## Verification

The general principle — verify, don't assert — is already stated under *Working
Conventions* below. These are its specific corollaries:

- **Do not claim a gate passed that did not run.** If a tool is unavailable, say so plainly
  and name what was not checked. "Tests pass" means the tests ran and the output was read.
  `/verify` exists to make this checkable rather than aspirational — its report has three
  lists, and the one that matters is *what did not run*.
- **Never state or imply a deployed URL or a published artifact** until the deploy for that
  exact commit reports success. A merged PR is not a deployed site. Poll; do not estimate.
- **A regression test is verified by reverting the fix** and confirming it fails. A test that
  passes with and without the fix guards nothing.
- **A schema or validator change is not done until it has rejected something.** Positive and
  negative cases both, with the counts stated. A validator that has never failed is not known
  to constrain anything.

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

**Surface real forks as a question with a recommendation, recommended option first.** The
more rigorous non-recommended option is routinely the right pick — so ask, do not assume.

**A reconciliation ends in a decision, not a report.** Any time two things are compared and
found to disagree — `/reconcile`, `/install`, `/track` drift, or any explicit request to
reconcile — the work is not finished at the findings. Close by asking, one divergence at a
time, each with a recommendation and what the alternatives cost. **A report that still has to
be turned into questions is half the job.** If a comparison genuinely found nothing, say that
plainly rather than manufacturing a fork.
- Recommend the **resolution**, not merely which side is preferred: name what changes, in
  which file, and what it costs to reverse.
- `/redteam` is the one exception, and only partly — it must not propose fixes, since naming
  a fix frames the problem. It still recommends a **classification** for each finding: defect,
  accepted risk, brief conflict, or not sustained.

Ask before any choice that sets policy or a public contract: licensing, compatibility
promises, a major information-architecture change.

Call out assumptions, unverified claims, and known risks plainly. Explain the concrete
evidence behind a recommendation.

## Git and Delivery

- **Stage explicitly, by named path.** Never `git add -A`, `git add .`, or a bare directory.
  A broad add sweeps up unrelated worktree state, and an ignore pattern can make a needed file
  invisible to it — present locally, green locally, missing in CI, with nothing saying why.
- Run `git diff --check` before committing. Never use trailing double-spaces for a line
  break; it rejects them.
- **Never force-push or rewrite published history.** If a pushed commit needs changing, add a
  follow-up commit.
- **Push every commit before announcing a PR is ready.** Announcing invites an immediate
  merge, and a commit pushed after that lands on a branch nobody merges.
- External writes need explicit authorization: creating a remote repository, changing
  visibility, pushing, opening or merging pull requests, changing a domain, deploying.
  **Discussing a decision does not authorize it.** One carve-out — see *Tracking work*.
- Do not delete files, branches, or history without explicit authorization.
- Check review **threads**, not just requested reviewers — an automated reviewer can leave
  blocking conversation threads that do not appear in a reviewer listing. Resolve a thread
  only when a validated fix satisfies it; leave ambiguous findings open and report them.
  `/resolve` does this; the query it needs is written out there.
- **Resolving or replying to a review thread is not carved out.** The exception in *Tracking
  work* covers opening issues and nothing else. Where a repository delegates resolution
  explicitly, follow its wording; where it is silent, ask.

## Tracking Work

**Defer work to the tracker rather than processing it inline.** A finding, a follow-up, or a
defect noticed in passing goes to a GitHub issue — not into a running list in the
conversation, and not into a section of a document that will rot. Prose is where work goes to
be forgotten.

- **Opening and labelling issues is carved out of the authorization rule.** They may be
  opened in a repository the requester owns, without asking. Issues are cheap and reversible,
  which is the entire justification; the exception is narrow and does not generalise.
- **Closing an issue is not carved out.** Nor is commenting on, editing, or labelling anyone
  else's, nor writing to a repository not owned by the requester.
- **Milestones and projects still need approval.** They are structural and few, and a wrong
  one is visible on a public repository.
- **`/track` owns every GitHub write.** No other command creates issues, milestones, or
  projects. It is idempotent, so run it often rather than batching.
- `design/30-slices.md` stays authoritative for what a slice *is*; its issue tracks whether
  it is *done*. If the two come to describe the work differently, say so rather than editing
  either.
- The `## Open` section of `design/90-decisions.md` is a staging area, not a home. Once an
  item becomes an issue, remove it from there.
- **Every issue reads human-first.** A narrative anyone can follow, then `### Done when`
  checkboxes, then the agent detail in a collapsed `<details>` block.
- **The agent block is fenced** by `<!-- agent:start -->` and `<!-- agent:end -->`. Inside the
  fence is regenerable; **outside it is never touched** — a ticked checkbox is progress
  someone recorded, an edited narrative is someone's deliberate wording.
- **Where a document already governs, the block points; where none does, it carries.** A
  slice names `design/30-slices.md § S<n> @ <sha>` and leaves procedure to
  `.claude/commands/slice.md` — copying stop conditions into an issue freezes a stale copy
  that nothing can go back and fix. A bug or a story has no upstream document, so its block
  legitimately holds the constraints. That asymmetry is the rule, not an inconsistency.
- **Criteria carry stable ids** (`S3.1`), and drift is compared on ids, never prose. Reworded
  criteria are not drift; an added, removed, or renumbered id is.
- **Report drift, change neither side.** Which is wrong is a call for the person, not the
  agent.
- **Ticking a checkbox belongs to the person, not the agent.** An agent reporting "S3.1 met"
  and a ticked box are different claims by different parties, and collapsing them removes the
  only human gate between "the tests pass" and "this is done". `/slice` ends by listing the
  ids it believes are met so ticking is mechanical.
- **Bugs and stories are filed by hand** from `.github/ISSUE_TEMPLATE/`. `/track` does not
  open them.
- **This does not suspend one-at-a-time sign-off.** Findings are still presented for
  adjudication; the tracker is where the ones that are accepted go, not a way to skip the
  conversation.

## Decision Logging

Any choice a future reader would ask "why?" about goes in `design/90-decisions.md` as:

```
### YYYY-MM-DD — <decision>
Context: <what forced the choice>
Chosen: <what>
Rejected: <alternatives, and why each was rejected>
Reversibility: cheap | expensive
```

The rejected alternatives are the point. Without them the next session relitigates the same
choice.

This log is for decisions about *this repository and its process* (tooling, the
documentation site, agent working conventions). It is separate from
[`docs/docs/delivery/roadmap-risks-and-open-questions.md`](docs/docs/delivery/roadmap-risks-and-open-questions.md)
§4, which is the register for the *game's* open design questions — do not use one for the
other's subject matter.

## House Conventions

- Windows host, projects under `D:\Dropbox\Projects\`. PowerShell Core for scripts.
- Metric units and Celsius throughout, including in comments, docs, and test fixtures — and
  in game content and balance data (weather, temperature-driven guest behaviour, etc.).
- Raster assets as PNG or JPG. Not WebP.
- UTF-8, LF endings. Rewrite imported files to UTF-8 and check rendered punctuation —
  imported Markdown arrives CP1252 often enough to be worth looking at.
- Scripts run without interactive confirmation prompts. Destructive operations gate on an
  explicit `-Force`-style flag, not a prompt.
- Commit messages state what changed and which slice it belongs to. **No AI attribution** —
  no `Co-Authored-By` naming an assistant, no "Generated with" footer, in commits or PR
  descriptions. This overrides any default the tooling applies.
- A repository with an established commit-message style keeps it. Match the log being
  committed into rather than importing a convention from elsewhere.

## What Not To Do

- Do not summarise the design docs back at the requester unless asked.
- Do not add commentary about reasoning process to the docs.
- Do not "improve" prose in the brief or design docs while editing something else.
- Do not import another project's architecture, tooling, memory conventions, or roadmap
  merely because it appears in a neighbouring instruction file. Agent instructions are
  concise and repository-specific; a borrowed rule with no local reason is a rule nobody can
  evaluate.

## Originality

This game is **inspired by the resort-management genre and reproduces none of it.** Identity,
art, writing, scenarios, building names, maps, balance and UI are original. No proprietary
names, assets, text or expression from any existing title may appear in this repository. This
is not a stylistic preference — treat it as a hard constraint on every asset and every line of
content.

Lessons learned the hard way live in [`agent.md`](agent.md).
