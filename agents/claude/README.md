# agent-workflow (Claude Code)

The Claude Code implementation of the bootstrap/exit discipline described in
[`../README.md`](../README.md) — read that first for the "why". This file is
the "how": install, mechanism, layout.

Nothing here knows what language your project is in. Every fact about a repo
is probed at runtime, so the same bundle behaves correctly in a Rust crate, a
Django service, a Terraform module, or a repo it has never seen.

---

## The Claude Code specifics

`SessionEnd` hooks fire on a 1.5-second budget and **cannot inject context
into the model** — by the time they run, there is no model turn left to
drive. `Stop` is the only late-firing event that can reach the model, and it
fires at the end of *every* turn, not at the end of the session. So the
nudge/breadcrumb/recover discipline (see `../README.md`) is built from:

- a `Stop` hook for the one-shot nudge,
- a `SessionEnd` hook for the breadcrumb,
- the `SessionStart` hook for recovery on the next session.

Set `AW_RETRO_MODE=block` if you want a hard gate that refuses to end a turn
until the review runs, or `off` to disable the nudge entirely.

A `PostToolUseFailure` hook journals **every failed tool call** automatically
— free, and the highest-signal friction data that exists. The agent appends
one line whenever something else surprises it:
`printf '%s\tfriction\t%s\n' "$(date -u +%FT%TZ)" "…" >> "$AW_JOURNAL"`.

---

## Install

### Locally (terminal sessions)

```bash
./install.sh              # install or upgrade (idempotent)
./install.sh --dry-run    # show the resulting settings.json without writing
./install.sh --uninstall  # remove hooks and skills; state is preserved
```

This installs into `~/.claude`, so it applies to **every** project — no per-repo
setup, nothing committed into your repositories. Existing hooks in your
`settings.json` are preserved; a `.agent-workflow.bak` backup is written.

Session state lives in `~/.claude/agent-workflow-state/<repo-key>/`, keyed by git
remote so clones and worktrees of the same project share it. Your repos stay clean.

### Everywhere else (Claude web, mobile, routines)

Cloud sessions never see your laptop's `~/.claude`, so the two halves install
differently:

**Skills — enable them on claude.ai.** Cloud and Cowork sessions load the skills
enabled for your claude.ai account, synced at session start. Add
`session-start`, `session-end` and `session-note` there once and they are
available in every session on every surface, with no repo and no setup script.
This is the bulk of the value, and it costs one upload.

**Hooks — one setup script per cloud environment.** Paste
[`cloud-setup-script.sh`](./cloud-setup-script.sh) into the **Setup script**
field of your environment at claude.ai/code (cloud icon above the message box →
environment → gear). It runs as root before Claude Code launches, installs the
bundle into the VM's `~/.claude`, and is snapshotted, so it runs once rather than
per session. Every session in that environment then gets the automatic
journalling, baseline and exit nudge, whatever repo is attached. The script
clones this bundle from `AW_BUNDLE_REPO`/`AW_BUNDLE_PATH` (defaults: this repo,
`agents/claude`) — override those env vars if you fork or relocate it.

That user-settings layer being read inside the VM is verified, not assumed: a
`Setup` and a `SessionStart` hook written to the VM's `~/.claude/settings.json`
both fired. What does not carry over is your *local* `~/.claude`, because it is
never uploaded — a transport gap rather than a policy block.

The skills work standalone. They drive plain `git` and `printf`, so the
claude.ai-only install is fully usable on its own — the hooks add the automatic
capture, the baseline and the nudge, but nothing in the gates depends on them.

---

## What you get

| | |
|---|---|
| `/session-start` | Bootstrap: prove the verification loop runs, check what is in flight, internalise conventions, pick up the previous handoff, fix the intent in writing. |
| `/session-end` | Eight-gate exit review (see `../README.md`). |
| `/session-note` | One-line journalling during the session. |

There is no CLI. The bootstrap hook exports `$AW_JOURNAL`, `$AW_BASE_SHA`,
`$AW_SESSION_DIR` and `$AW_STATE_DIR` through `$CLAUDE_ENV_FILE`, and the skills
use plain `git` and `printf` against them. That keeps one code path whether or
not the hooks are installed, instead of a command that may or may not exist.

Tab-separated, so reading a journal yourself between sessions needs nothing
beyond `cat`:

```bash
cat ~/.claude/agent-workflow-state/*/sessions/*/journal.tsv
```

---

## Layout

```
agents/claude/
  install.sh                       idempotent installer / uninstaller
  cloud-setup-script.sh            paste into a cloud environment's Setup script
  settings.snippet.json            the four hook registrations
  hooks/
    lib.sh                         shared probing + journal library
    session-bootstrap.sh           SessionStart  → inject repo facts
    journal-tool-failure.sh        PostToolUseFailure → auto-journal bumps
    session-exit-nudge.sh          Stop          → one-shot review reminder
    session-end-breadcrumb.sh      SessionEnd    → breadcrumb for recovery
  skills/
    session-start/SKILL.md
    session-end/SKILL.md
    session-note/SKILL.md
```
