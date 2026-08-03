---
description: Start a new project
argument-hint: [project name]
disable-model-invocation: true
---

Set up a new project: $ARGUMENTS

**Ask before creating anything.** Don't guess at what I'm trying to do — a
plausible-sounding scope I didn't agree to is worse than no file at all.

## Step 1 — check

Derive a kebab-case folder name from the argument. If `projects/<name>/`
already exists, stop and tell me rather than writing into it.

## Step 2 — ask

Ask me these, then wait for my answers:

1. **What are you actually trying to change?** One or two sentences.
2. **How will you know it worked?** A number, a signal, or an honest "I won't
   be able to measure this, I'll just judge it in a month."
3. **What are you tracking, and how often?** Or nothing, if this isn't a
   tracking project.
4. **When should we review this?** A date, or "no fixed date".

If I answer vaguely, say so and ask again once. Don't paper over it — a
project with no definition of done is the one that quietly rots.

## Step 3 — create

Only after I've answered:

- `projects/<name>/notes.md` — what this is, what "done" or "working" looks
  like, the review date. Write it from my answers, in my words, not expanded
  into filler.
- `projects/<name>/log.md` — only if I'm tracking something. Seed it with one
  dated entry recording that the project started and what the baseline is.
  Name it exactly `log.md`; the append-only rule is scoped to that filename.
- Add a line under **Active projects** in @PROJECT_STATE.md:
  `- **<name>** — <one-line status>`
- Update **Current focus** in `PROJECT_STATE.md` if this is now the focus.
  Ask me if it isn't obvious.

Don't create a `data/` folder, a README, or any other file until there's
something to put in it.

## Step 4 — decision record?

If choosing *this approach over another* involved real alternatives — a
different method, a competing plan I rejected — offer to run `/decide`. Don't
write one for the mere fact that I started a project.

Then show me what you created and stop.
