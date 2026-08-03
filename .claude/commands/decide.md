---
description: Write a decision record
argument-hint: [short decision title]
disable-model-invocation: true
---

Write a decision record for: $ARGUMENTS

1. Read @docs/decisions/INDEX.md to find the highest DR number. Use the next one.
2. Follow the structure of @docs/decisions/TEMPLATE.md.
3. Write it to `docs/decisions/DR-NNN-<kebab-case-title>.md`.
4. Fill it from this conversation. Don't invent alternatives we never
   discussed — if I only considered one option, say that.
5. **Consequences is the point.** Write what this costs and what it makes
   harder later, not just what it gives me.
6. Add one line to `INDEX.md`, newest last:
   `- [DR-NNN](DR-NNN-slug.md) — <one-line statement of the decision>`
   Use a plain markdown link, never `@` — an `@` reference would load the
   whole record into every future session.
7. If this supersedes an earlier record, set that record's status to
   `Superseded by DR-NNN` and update its index line. Never delete a record —
   a reversed decision still tells me what I already tried.

If you don't have enough detail for Context or Consequences, ask me rather
than filling it in with plausible text.
