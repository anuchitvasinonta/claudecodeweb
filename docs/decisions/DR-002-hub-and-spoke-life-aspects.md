# DR-002: Organize life aspects as a hub with flat spokes, created lazily

- **Status:** Accepted
- **Date:** 2026-08-04

## Context

The `self-reflection` project names four aspects — relationships, health,
keeping up with knowledge, and a self-run revenue-generating business — each
of which needs its own goals, plan and tracking. Something had to decide where
those live relative to each other and to the umbrella project, before the
first one was created and the shape got locked in by accident.

A second question was bound up with it: whether all four start at once.

## Options considered

1. **Nested under the hub** — `projects/self-reflection/health/` and so on.
   Keeps the family visibly together. Lost because the repo's convention is
   one project per folder directly under `projects/`, and `/project` writes to
   `projects/<name>/`; nesting would have required changing both for no gain
   the hub's links don't already provide.
2. **One project, four files** — everything inside `self-reflection/`.
   Simplest, but the append-only `log.md` rule is per-file, so four aspects'
   tracking would interleave in one log and become unreadable.
3. **Four independent projects, no hub** — rejected. Nothing would hold the
   cross-aspect view, which is the entire point of the umbrella project: the
   aspects compete for the same finite free time, and that tradeoff needs
   somewhere to live.
4. **Hub with flat spokes** — chosen.

On sequencing, the alternative was starting all four aspects at once. Rejected
in conversation: four simultaneous projects is a lot of surface area for a
project whose premise is having free time, and it's the version that most
often stalls.

## Decision

The hub (`projects/self-reflection/`) holds direction, the aspect list, review
cadence and cross-aspect tradeoffs. Each aspect is a sibling folder directly
under `projects/`, linked from the hub, owning its own goals and its own
`log.md`. Aspects start one or two at a time, and **an aspect gets a folder
only when it actually starts** — until then it is a named line in the hub.
Metrics live in the aspect that owns them and are never copied into the hub.

## Consequences

- `PROJECT_STATE.md` lists only aspects that are actually running, which keeps
  it short and true. Per DR-001 every `@`-imported file loads in full every
  session, so this is a real context saving, not tidiness.
- The repo never claims to be doing more than it is. Four folders of
  intentions would read as active work in every future session.
- **The cost:** when a dormant aspect starts, its folder is empty and gets
  written from scratch. Any thinking done about it in the meantime lives in
  the hub or nowhere.
- Reversing it means moving folders and rewriting the hub's links — cheap now,
  progressively less so as each aspect accumulates history.

## Open items

The user asked for a recommendation on structure and then built on it rather
than agreeing in so many words; the folders now exist in this shape. Recorded
as Accepted on that basis. If that reading is wrong, this record should be
superseded rather than edited.
