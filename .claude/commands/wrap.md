---
description: Update the project brain before ending a session
disable-model-invocation: true
---

We're finishing this session. Update the repo so the next session starts
informed. Work only from what actually happened in this conversation.

First run `git status` and `git diff --stat` to ground yourself in what changed.

Then, in order:

1. **@PROJECT_STATE.md**
   - Update Current focus if it moved
   - Move finished items out of In progress
   - Update In progress to reflect reality, not intention
   - Add anything that became blocked, and say what would unblock it
   - Delete entries that are no longer live — this file is current state, not
     history

2. **Decision records** — if we made a decision a future session would ask
   "why?" about, write one with `/decide`. Signals: we chose between real
   alternatives, we rejected an obvious option, or we accepted a tradeoff.
   Routine progress does not need a record.

3. **@docs/working/open-questions.md**
   - Add questions raised today
   - Remove any we answered, and note the answer

4. **CLAUDE.md or .claude/rules/** — only if we established a durable rule.
   If I corrected you on the same thing twice today, that belongs in a rule.

Constraints:

- Only modify files whose content actually changed. Don't touch a file just
  because it's on this list.
- Record decisions, rationale, and constraints. Don't narrate the diff.
- Don't write anything I didn't actually say or agree to. If you're unsure
  whether something was a decision or just an idea we floated, ask.

Show me the doc changes before committing. Then commit with a message
summarizing the session.
