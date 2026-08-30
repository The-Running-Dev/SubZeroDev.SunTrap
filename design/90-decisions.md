# Decision log

Append-only. Newest at the top. The rejected alternatives are the point — without them, every future session relitigates the same choice.

## Open
<A staging area, not a home. Things noticed mid-slice that were deliberately not acted on. `/track` turns each into a GitHub issue and removes it from here. An item that is a *decision* rather than a *todo* belongs below as an entry, not in an issue.>

---

### 2026-08-30 — `/clean` and `/done` consolidated to `/clean`; `/done` retired
Context: `/kit-sync` found two housekeeping commands doing the same job. `clean.md` was added
fresh by the previous sync (`0e1cca0`, kit commit `d57880d`) as the kit's current core. `done.md`
was this repository's pre-existing command under a different name, hand-patched in that same
sync but left on the superseded `<!-- companion:start -->` marker (every other command file in
the repository already used `<!-- companion:declared:start -->`) and missing the squash-merge
force-delete flow `clean.md` had. `CLAUDE.md`'s Command routing table and this file's own
2026-08-13 entry referred to `/done`, not `/clean`.
Chosen: Adopt the kit's own naming. Deleted `done.md`; kept `clean.md` as installed by
`Sync-Kit.ps1`. Renamed every live `/done` reference to `/clean` in `CLAUDE.md` (the Command
routing table row and the branch-deletion delegation bullet, which also picked up the
squash-merge force-delete wording new in kit commit `5095a55`). The 2026-08-13 entry's own
`/done` reference was left as written — it is a historical record of what was true then, not a
live pointer. Neither `clean-local.md` nor `done-local.md` existed, so no companion content was
at risk. `/clean`'s tier was kept at this repository's existing `haiku`/`low` rather than the
kit's `sonnet`/`medium` — that divergence predates this sync (it was already `/done`'s tier) and
was not part of what this reconciliation was asked to decide.
Rejected: **Keep `/done`, retire `clean.md`** — matches the pre-existing local name with less
churn to `CLAUDE.md` right now, but diverges from the kit's own command name forever, so every
future re-install re-adds `clean.md` as `Absent` and this repository would delete it again on
every sync. **Keep both as genuinely separate commands** — rejected outright; they do the same
job and nothing distinguishes them on purpose.
Reversibility: cheap — a documentation rename and one file deletion; recoverable from git
history if the direction should flip.

### 2026-08-30 — `codex/PROFILES.md` installed; supersedes the 2026-08-04 skip
Context: The 2026-08-04 install skipped `codex/PROFILES.md` for lack of evidence of Codex use.
The 2026-08-29 sync (`0e1cca0`) subsequently installed `tools/Invoke-CodexCommand.ps1`, whose
own header comments name `codex/PROFILES.md` as its source of truth for per-profile `model` and
`model_reasoning_effort` values, and `CLAUDE.md` already carries the full Codex vendor-alias
table. The file itself was never added.
Chosen: Install `codex/PROFILES.md` from the kit, unmodified, at the repository root.
Rejected: **Continue skipping it** — the original default, but the evidence bar `INSTALL.md`
sets (a profile reference) was already met by `Invoke-CodexCommand.ps1`'s own comments; skipping
further leaves a script pointing at a file that does not exist.
Reversibility: cheap — a documentation file with no dependents until a Codex session reads it.

### 2026-08-30 — `CLAUDE.md` reconciled forward to kit commit `5095a55`
Context: `.claude/commands/*`, `tools/*.ps1` and `.claude/COMPANIONS.md` were brought current by
`Sync-Kit.ps1` (`d57880d` → `5095a55`, 12 commits), but `CLAUDE.md`'s hand-merged process
content had not been re-reconciled since the 2026-08-29 sync. Diffing kit `AGENTS.md` across
that range showed three additions: a `/next` Command routing row (`.claude/commands/next.md` is
new in this range), the squash-merge force-delete delegation wording folded into the `/clean`
consolidation above, and a new "Writing a design-state record" section. A fourth change — tier
resolution from an `AGENTKIT_TIER` environment stamp before falling back to on-disk config — was
left out: it only matters for a Codex session invoked through `tools/Invoke-CodexCommand.ps1`,
and is `codex/PROFILES.md`'s and that script's territory to document, not a duplicate copy here.
Chosen: Add the `/next` row. Add the "Writing a design-state record" section verbatim — it
self-scopes to "where this repository's own `design/state/` exists," which is not yet true here
(no `design/state/` directory), so it lands as correct future documentation rather than a
live-but-inapplicable rule. Left the existing, differently-scoped "Committing and pushing to a
non-default branch are delegated in this repository" bullet as-is rather than replacing it with
kit's newer "No work lands directly on the default branch, ever" wording plus its
`design/state/`-record exception — the target's rule already covers this repository's actual
practice and the exception has no `design/state/` records to except yet.
Rejected: **Also install the `design/state/`-record exception's base bullet, replacing the
target's own** — rejected because the two bullets differ in framing (a delegation grant vs. a
prohibition-with-exception), the target's was written against this repository's real branching
practice, and nothing here yet exercises the exception it would add.
Reversibility: cheap — documentation only; each addition can be reverted independently of the
others.

### 2026-08-13 — Reconcile `CLAUDE.md`'s process contract forward to kit commit `6bdd8dc`
Context: `.claude/commands/*`, `tools/*.ps1`, and `.claude/COMPANIONS.md` had already been
brought current to kit `HEAD` by `Sync-Kit.ps1` (`.claude/kit.json`'s `syncedCommit` already
read `6bdd8dc`), but `CLAUDE.md`'s hand-merged process-contract content had not been
re-reconciled since the original `2026-08-04` install at kit commit `9b8313c`. Diffing the
two showed `CLAUDE.md` was missing everything the kit's `AGENTS.md` gained across the ~20
commits between them: the work-start and session-boundary banner conventions, the expanded
delegation carve-outs (non-default-branch push, `/done`'s branch deletion, `/resolve`'s
thread resolution, checkbox ticking, closing/labelling issues), the full `design/FROZEN.md`
marker mechanism and template (previously only a condensed summary paragraph), the "never
hand back a diff, make the edit" rule, and the `Measure-Session.ps1` Codex/Copilot
measurement caveat.
Chosen: Merge all of it into `CLAUDE.md`'s existing structure, in this repository's
established voice (Title Case headers, "the requester"/"the person" instead of "I"/"me"),
the same pattern the `2026-08-04` merge used. Two of the kit's own internal invariant-id
citations (`I6`, `I9`) were dropped rather than carried over — they reference numbered
invariants in the kit's own `design/20-contract.md`, which is never installed into a target,
so citing them here would be a dangling reference. Also added the `UserPromptSubmit` hook for
`tools/Measure-Session.ps1` alongside the existing `SessionEnd` hook in `.claude/settings.json`
(`pwsh` confirmed on `PATH`, no existing hook on that event) and bumped `.claude/kit.json`'s
`commit` field to `6bdd8dc` — it had never been updated past the original `9b8313c` install
even though `syncedCommit` had moved on.
Rejected: **Leave `CLAUDE.md` as the more conservative, already-signed-off contract** — the
other option presented; rejected because the gap traced to staleness (the manual
`AGENTS.md`/`CLAUDE.md` reconciliation step was simply never re-run after the command/tooling
sync), not to a deliberate policy choice recorded anywhere, and the newer kit content is
itself a record of decisions already made and reasoned through in the kit's own history.
Reversibility: cheap — a documentation and hook-config merge only; any individual section can
be reverted without touching tooling or process state.

### 2026-08-10 — Reconcile Sun Trap's dependency status to GameEngine 0.5.0
Context: Sun Trap's README, standing instructions, agent orientation, roadmap and
implementation programme still said the `world-graph` kind and companion-package surface
were pending. GameEngine W41–W49 have since merged, `v0.5.0` exports the kind and its campaign
interfaces, and the public `@the-running-dev/game-engine@0.5.0` package was verified through
the GitHub Packages API. Sun Trap still has no executable content and has not pinned the
dependency. The programme also requires named evidence for every checked task, so the
existence of the release cannot close M2–M6 wholesale.
Chosen: Update the orientation and delivery documents now; check the verified M0 and
engine-owned M1 work with immutable evidence; leave Sun Trap's dependency task and all M2–M6
tasks unchecked until their own audits. Rewrite the immediate packet around that audit, the
remaining game-owned decisions, and an exact `0.5.0` dependency.
Rejected: **Leave every status statement unchanged until M2–M6 are fully audited** — rejected
because it knowingly briefs future sessions with two false blockers and hides the supported
package they must consume. **Mark M2–M6 complete from the release alone** — rejected because
a release proves distribution, not every task and gate in Sun Trap's independently written
programme.
Reversibility: cheap — documentation and checklist evidence only; later audits can check or
retain each M2–M6 item without changing the package decision.

### 2026-08-04 — `SessionEnd` hook installed for `tools/Measure-Session.ps1`
Context: `INSTALL.md` requires proposing the `SessionEnd` hook interactively and waiting for sign-off — it is never installed unattended, which is why the earlier `/install-all` run left it out. This follow-up `/install` run is interactive: `pwsh` is on `PATH`, `tools/Measure-Session.ps1` was already in place from that run, and the target had no `.claude/settings.json` at all, so there was no existing hook to conflict with.
Chosen: Create `.claude/settings.json` containing only `hooks.SessionEnd`, running `pwsh -NoProfile -File "tools/Measure-Session.ps1"`. No other key was added.
Rejected: **Leave the hook uninstalled** — the safe default while unattended, but no longer the right call once a person could actually approve it; leaving it out would just defer real cost reporting for no reason.
Reversibility: cheap — deleting the file or the `SessionEnd` key removes the hook with no other effect.

### 2026-08-04 — Kit installed via `/install-all`; `CLAUDE.md` keeps holding content, `AGENTS.md` becomes the pointer
Context: `SubZeroDev.AgentKit` (commit `9b8313cd67cbfbf38c95d105b7f35fffe341532d`) was reconciled into this repository unattended. `CLAUDE.md` already held substantial, actively maintained project content; `AGENTS.md` did not exist. `INSTALL.md`'s `AGENTS.md`/`CLAUDE.md` rule for this state — one file holds content, the other is absent — recommends keeping the existing direction as the smaller change, and `install-all.md` treats that recommendation as the deterministic resolution rather than a fork to ask about.
Chosen: Leave the project contract in `CLAUDE.md` and merge the kit's process sections into it (Model/Effort/Review Budget, Hard Rules, Single Ownership, Verification corollaries, Git and Delivery, Tracking Work, Decision Logging, House Conventions, What Not To Do, plus additions to the existing Working Conventions section). `AGENTS.md` was created as a one-line pointer to `CLAUDE.md`, mirroring the kit's own pointer pattern in reverse, so tools that look for `AGENTS.md` by convention still find the contract. Two rules already present in `CLAUDE.md`'s Working Conventions section — "findings one at a time for sign-off, record declines" and "verify, don't assert" — duplicated kit rules on the same subject; the target's existing wording was kept and the kit's duplicate wording was dropped rather than restated.
Rejected: **Move the content into `AGENTS.md` and reduce `CLAUDE.md` to a pointer** — the other option `INSTALL.md` names; rejected because it is the larger edit for no behavioural gain, and every existing external reference to this repository's instructions points at `CLAUDE.md`.
Reversibility: cheap — the pointer direction can be flipped later without content loss, since nothing was deleted, only added.

### 2026-08-04 — `agent.md` kept as-is; the kit's seed lessons were not merged
Context: `agent.md` already existed with maintained, repository-specific content (game-domain lessons plus lessons inherited from `SubZeroDev.GameEngine`). `INSTALL.md` states that where the target's lessons file has content, it wins wholesale and the kit's seed is not merged in bulk — individual kit lessons may only be offered one at a time, with sign-off, where a lesson is both demonstrably absent and demonstrably applicable. This install ran unattended (`/install-all`), with no one available to sign off on individual offers.
Chosen: Leave `agent.md` untouched. No kit lessons were added.
Rejected: **Merge the kit's seed lessons in bulk** — against `INSTALL.md`'s explicit rule that the target's file wins wholesale. **Offer individual lessons one at a time** — the correct interactive path, but unavailable without a human to answer; deferred to a future interactive `/install` run rather than guessed at here.
Reversibility: cheap — nothing was changed.

### 2026-08-04 — `design/` installed at the repository root; distinguished from `docs/docs/design/`
Context: The kit installs its process design-doc chain (`00-brief.md`, `10-design.md`, `20-contract.md`, `30-slices.md`, `90-decisions.md`) at root `design/` by default. This repository has no root `design/` directory and no `plans/`/`adr/`/`rfc/` equivalent, but it does have `docs/docs/design/`, which holds the game's own domain-design content (`game-design.md`, `content-and-systems.md`) — a different thing with a similar-looking path.
Chosen: Install the kit's `design/` at the repository root, unchanged from the kit's default (no relocation needed — `design/` was not occupied and there is no competing process-documentation home). Added a clarifying paragraph to `CLAUDE.md`'s new "Process Documentation (`design/`)" section stating explicitly that root `design/` is for repository/process work and is distinct from `docs/docs/design/`, which stays game-domain content, to head off the naming collision being confused in practice. `10-design.md`, `20-contract.md`, and `30-slices.md` were installed empty, matching the kit's own unwritten state for those files.
Rejected: **Skip installing `design/` and rely on `docs/docs/delivery/roadmap-risks-and-open-questions.md`** — that document is real, but it is game-domain content (phases, risks, open questions about the game), not a brief/contract/slice/decision chain for changes to the repository's own tooling and process; it does not compete with what `design/` adds.
Reversibility: cheap — nothing referenced these files before this install; deleting them costs nothing so far.

### 2026-08-04 — `codex/PROFILES.md` skipped; no evidence of Codex use
Context: `INSTALL.md` skips `codex/PROFILES.md` by default unless the target shows evidence of Codex use — a `.codex/` directory, a profile reference, or explicit confirmation. Neither was found in this repository.
Chosen: Skip `codex/PROFILES.md`. Report it as skipped rather than installing it speculatively.
Rejected: **Install it anyway** — against `INSTALL.md`'s explicit default and the stated prohibition on installing it into a repository that has never been used with Codex.
Reversibility: cheap — a future `/install` can add it once Codex use is evidenced.
