@CLAUDE.md

Everything in `CLAUDE.md` applies. It is the single agent contract for this repo. `CLAUDE.md`
holds the content because Claude Code loads it directly; this file exists so tools that look
for `AGENTS.md` by convention (Codex and others) find the same contract.

If `@CLAUDE.md` import is not resolving in your version, replace this file with a hardlink:

```powershell
# from repo root, PowerShell as admin not required for hardlinks on same volume
New-Item -ItemType HardLink -Path AGENTS.md -Target CLAUDE.md -Force
```
