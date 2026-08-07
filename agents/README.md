# agents

Vendor-agnostic principles for how coding-agent sessions should bootstrap and
exit, plus a per-vendor implementation of them under this directory (currently
[`claude/`](./claude/) for Claude Code; add siblings here as needed rather than
letting these ideas live captive inside one vendor's config format).

## Why bootstrap and exit are the two moments that matter

Two moments decide whether a session was worth it, and neither is the middle.
**Bootstrap** decides whether the agent is working from knowledge or from
guesses. **Exit** decides whether anything learned survives the session, or
dies with the context window.

## Records during, synthesises at exit

A retrospective written from memory at the end of a long session is the least
reliable one available: early friction has been compacted out of context, and
the gaps get filled with plausible-sounding bumps that never happened. So the
discipline is to journal friction as it happens — every failed tool call,
automatically, plus a one-line note whenever something surprises the agent —
and turn "what went wrong today?" into a reading exercise at exit rather than
a memory test.

## Nudge once, leave a breadcrumb, recover next time

A hard, fully-automatic "run the retrospective when the session ends" is
often not achievable — many agent runtimes cannot inject context into the
model from a late-firing/session-teardown event. The fallback that is
achievable, in three parts:

1. **Nudge once.** Trip a single reminder per session, only once the session
   has actually produced work. One reminder, not a per-turn nag.
2. **Leave a breadcrumb.** If the session ends without the review running,
   record that fact and preserve the journal.
3. **Recover next time.** The next session's bootstrap sees the breadcrumb
   and offers to run the review over the preserved evidence — findings from a
   session that ended abruptly are still valid, they just have not been
   banked yet.

## The eight exit gates

| Gate | Question |
|---|---|
| **G0** Scope drift | Did we ship what was asked — no less (silent narrowing) and no more (unrequested extras)? |
| **G1** Verification honesty | Is every "this works" traceable to a command that actually ran? Unverified claims are named as unverified. |
| **G2** Conventions | Linters pass *and* the code matches what neighbouring files actually practise. |
| **G3** Docs | Nothing stale, nothing missing, nothing newly discovered to be already wrong, nothing stated twice. |
| **G4** Blast radius | What cannot be walked back — pushed, published, migrated, deleted — plus a secret sweep and dependency delta. |
| **G5** Agent retro | Each bump → root cause → prevention lane: human practice, instruction change, tooling, or accept. |
| **G6** Repo retro | Undocumented structural anomalies, scored criticality × remediation cost, with a routing matrix. |
| **G7** Handoff | Open loops, decisions with rejected alternatives, and the next session's starting point. |

Every gate ends in **PASS with evidence** or a **FINDING with severity and a
next action**. "Looks fine" is not an allowed outcome — a gate that always
passes is a ritual, not a gate.

## The part that compounds

G5 does not stop at naming what went wrong. Each bump is routed to a
prevention lane, in preference order:

1. **Tooling** — a hook, CI check, or lint rule that makes the error impossible.
2. **Instruction change** — exact, copy-pasteable text for the project's agent
   instructions file.
3. **Human practice** — a concrete change in how you brief the agent.
4. **Accept** — prevention costs more than recurrence. A legitimate answer.

The bias toward tooling is deliberate: a rule in a document is only as strong
as the attention budget of whoever reads it next, whereas a check that fails
loudly is not.

Over N sessions a project's agent instructions converge on its *actual*
behaviour instead of its imagined one — and that is the whole point. Each
session's friction becomes the next session's guardrail.

## Implementations

- [`claude/`](./claude/) — Claude Code: hooks, skills, install scripts.
