# The Project Brain

How to give Claude Code durable memory of a project by putting knowledge in
git instead of relying on chat history.

This is the reference document. The rest of this repo is a working
implementation of it.

---

## 1. The problem this solves

**Every Claude Code session starts with a fresh context window.** This is true
on every surface — web, desktop app, CLI. A new session knows nothing about
what happened in your previous sessions.

Two clarifications that are commonly gotten wrong:

**Sessions persist; memory across sessions does not.** A web session stays in
the sidebar at claude.ai/code with its full conversation history. If the VM is
reclaimed for inactivity it's marked *expired*, and reopening it provisions a
fresh VM with the conversation restored. `claude --teleport` pulls a cloud
session into your terminal with history intact. So *resuming yesterday's
session* works fine. It's *new* sessions that start blank.

**The desktop app is not different.** From the docs: "In the Code tab, each
conversation is a session: it has its own chat history, project folder, and
code changes, independent of any other session." Desktop's sidebar of past
sessions is the same resume mechanism the web has.

**Auto memory exists but won't carry you.** Claude writes its own notes to
`~/.claude/projects/<project>/memory/MEMORY.md`, and the first 200 lines (or
25KB) load into every session automatically. But: it's machine-local and
explicitly *not shared across machines or cloud environments*, so it's absent
in web sessions entirely; it's capped; and it records what Claude judged worth
remembering — build commands, tool quirks — not what you decided or why.
Treat it as a free bonus layer, never as the project brain.

**Why not just keep the transcripts?** Even if you backed up and restored
every conversation, it wouldn't work. Restored history doesn't enter new
sessions — you'd have to resume that exact session, which grows until
auto-compaction *replaces the conversation with a structured summary*. And a
transcript is a bad knowledge format anyway: most of it is dead ends, tool
output, and decisions later reversed. A curated decision record beats a
perfect transcript.

**Conclusion:** the only thing that reliably survives is what's committed to
git. That's the whole strategy.

---

## 2. The eight guidelines

1. **`CLAUDE.md` under 200 lines.** Loaded in full, every session, every
   surface. It's an index and a rulebook, not a manual. Longer files consume
   more context *and* reduce adherence.

2. **Point at a decision *index*, never at the decision files themselves.**
   One line per decision. Claude opens a full record only when it's relevant.
   Loading every decision at startup is how you burn your context budget
   before typing anything.

3. **One status file.** `PROJECT_STATE.md`. Not one for humans and one for AI
   — Claude reads human markdown fine, and two files drift within weeks, at
   which point you have two wrong answers.

4. **Path-scoped rules for constraints.** `.claude/rules/*.md` with `paths:`
   frontmatter. The rule loads only when Claude touches a matching file, so
   it's loud where it matters and absent where it doesn't.

5. **Commands for rituals.** `/start`, `/project`, `/wrap`, `/decide`. Turns a four-step
   prompt you'd have to remember into one word.

6. **Skills for procedures.** `.claude/skills/<name>/SKILL.md`. Loads on
   demand, costs nothing until used. Good for long reference material.

7. **Hooks for what must not be optional.** CLAUDE.md is *context, not
   enforced configuration* — Claude can rationalize past it. A hook runs
   regardless of what Claude decides.

8. **Don't pre-create empty docs.** An empty `goals.md` costs tokens and
   teaches nothing; a stale one actively misleads. Add a file when you have
   content for it. Also skip anything Claude can derive by looking — file
   listings, obvious structure. Keep the pitfalls, the rationale, and the
   conventions that differ from defaults.

**Budget:** `CLAUDE.md` + `PROJECT_STATE.md` + unscoped rules + everything
imported with `@` should total under ~200 lines. Verify with `/context`,
which lists what actually loaded under **Memory files**.

---

## 3. How `@` imports work

In `CLAUDE.md`, `@path/to/file` is an **import, not a pointer**. Claude Code
splices that file's entire contents into CLAUDE.md at session start.

```markdown
- Current state: @PROJECT_STATE.md        ← file is loaded in full, every session
- Decisions: `docs/decisions/INDEX.md`    ← just text; read on demand
```

Three consequences:

- **Imports are recursive, up to 4 hops.** If your index contained
  `@docs/decisions/DR-001-....md`, that record would load at startup too — and
  anything *it* imports. Use plain markdown links in the index
  (`[DR-001](DR-001-slug.md)`), never `@`.
- **To name a path without importing it, wrap it in backticks.** Import
  parsing skips code spans.
- **Splitting a long CLAUDE.md into imports saves nothing.** The tokens land
  in context either way. It's organizational only.

Import only what's needed every single session. In practice that's the status
file and the decision index.

---

## 4. Layout

```
repo/
├── CLAUDE.md                 # entry point, <200 lines, always loaded
├── PROJECT_STATE.md          # the one status file, always loaded
├── README.md
├── .claude/
│   ├── settings.json         # hook wiring
│   ├── commands/             # /start /project /wrap /decide
│   ├── hooks/                # session-start.sh, protect-paths.sh
│   ├── rules/                # path-scoped constraints
│   └── skills/               # on-demand procedures (add as needed)
├── docs/
│   ├── decisions/
│   │   ├── INDEX.md          # one line per decision — CLAUDE.md points here
│   │   ├── TEMPLATE.md
│   │   └── DR-001-*.md
│   └── working/
│       └── open-questions.md
└── projects/                 # one folder per project
```

**One repo or many?** For unrelated software projects, one repo each —
`CLAUDE.md`, rules, and memory scope are all per-repository, and mixing them
means every session loads context for projects you aren't touching. Related
efforts that genuinely share context (the same person, the same calendar, the
same constraints) can share one repo with a folder per project, which is how
this repo is set up.

---

## 5. The files

### `CLAUDE.md`

The operating manual. Three jobs: say what this repo is, point at the
always-loaded files, and state the rules that apply everywhere. Everything
narrower belongs in a path-scoped rule; everything longer belongs in a doc
that gets read on demand.

### `PROJECT_STATE.md`

Where things stand *right now*. Current focus, done, in progress, blocked,
next. Keep it under ~60 lines — delete stale entries rather than appending
forever. This is the file `/wrap` updates and the SessionStart hook injects.

### `docs/decisions/`

The highest-value part of the system, and the one that pays off latest.
`INDEX.md` is one line per decision and is what `CLAUDE.md` points at.
Individual records hold context, options considered, the decision, and
consequences.

The point is capturing **why**. Six months on, "why does this exist" is
exactly what re-reading old chats would never give you cleanly, because the
reasoning is scattered across dead ends and reversals.

Records are append-only in spirit: supersede, never delete. A decision you
reversed is still information — it tells you which approach you already tried.

### `docs/working/open-questions.md`

Things you're waiting on or haven't decided. Cheap to maintain, and it stops
the same unresolved question from being re-litigated every few weeks.

### `.claude/rules/*.md`

Constraints scoped with `paths:` frontmatter:

```markdown
---
paths:
  - "projects/**/log.md"
---

# Logs are append-only
- Add new dated entries at the top. Never edit or delete past entries.
```

Rules without a `paths` field load unconditionally, same as CLAUDE.md — so
use `paths` unless the rule genuinely applies to everything.

---

## 6. The commands

Files in `.claude/commands/*.md` become `/name`. Custom commands and skills
have merged: `.claude/commands/wrap.md` and `.claude/skills/wrap/SKILL.md`
both create `/wrap` and support the same frontmatter. Commands files are
simpler (one file); skills add supporting-file directories.

`disable-model-invocation: true` stops Claude from firing these on its own —
you don't want a doc rewrite triggered in the middle of unrelated work.

- **`/start`** — deeper onboarding: reads the decision index, relevant
  records, and open questions, then reports what it understands and flags
  anything that looks stale. Skip it for small tasks; the SessionStart hook
  already injects the state file.
- **`/project <name>`** — starts a project. Asks scope questions *before*
  creating anything, then makes the folder and adds the line to
  `PROJECT_STATE.md`. That second half is the part worth automating: a
  project folder that isn't registered in the status file is invisible to
  every future session, since nothing loads `projects/` automatically.
- **`/wrap`** — the load-bearing ritual. Updates the status file, writes a
  decision record if a real decision was made, updates open questions,
  promotes repeated corrections into rules, commits.
- **`/decide <title>`** — writes the next numbered decision record from the
  template and adds its index line.

Useful substitutions inside command files: `$ARGUMENTS` (everything passed),
`$0`/`$1` (positional), `${CLAUDE_PROJECT_DIR}` (repo root).

---

## 7. The hooks

Wired in `.claude/settings.json` under a top-level `hooks` key, three levels
deep: event → matcher group → handlers.

**SessionStart** injects text into context automatically, so it doesn't depend
on Claude choosing to read a file. Matchers: `startup`, `resume`, `clear`,
`compact`, `fork`. Emit:

```json
{ "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "..." } }
```

**PreToolUse** gates tool calls. Matcher is the tool name (`Edit|Write`,
`Bash`, `mcp__server__.*`). Emit:

```json
{ "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "..." } }
```

`permissionDecision` accepts `deny`, `allow`, `ask`, or `defer`. Use `ask` to
escalate to yourself rather than hard-blocking — usually the right choice for
personal work.

**Exit codes matter.** Exit 0 → stdout is parsed as JSON. Exit 2 → blocking
error, stdout ignored, stderr fed back to Claude. **Exit 1 is non-blocking**
— a common mistake. Choose one approach: exit codes alone, or exit 0 with
JSON.

Hooks in `.claude/settings.json` are committed and shared; `.claude/settings.local.json`
is gitignored and personal.

---

## 8. The workflow

**Starting.** Open a session. The SessionStart hook puts the state file and
git context in front of Claude automatically. Run `/start` when you want the
fuller read.

**Working.** Normal work. No ceremony.

**Ending.** Run `/wrap`. This is the part that makes everything else work —
the rest of the system degrades gracefully, this one doesn't. Twenty seconds
of `/wrap` is what makes tomorrow's blank session useful.

**Periodically.** Prune. A doc nobody deletes becomes a doc nobody trusts. If
`PROJECT_STATE.md` is over 60 lines or `CLAUDE.md` is over 200, cut rather
than reorganize.

---

## 9. Reference

Commands worth knowing:

| Command | Does |
| :--- | :--- |
| `/context` | Shows what actually loaded this session — use it to verify your setup |
| `/memory` | Lists CLAUDE.md locations, toggles auto memory |
| `/init` | Generates a first-draft CLAUDE.md from an existing codebase |
| `/doctor` | Proposes trims for an oversized CLAUDE.md |
| `/compact` | Summarizes the conversation to free context |

Docs:

- [How Claude remembers your project](https://code.claude.com/docs/en/memory)
- [Claude Code on the web](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Desktop application](https://code.claude.com/docs/en/desktop)
- [Explore the context window](https://code.claude.com/docs/en/context-window)
- [Skills and custom commands](https://code.claude.com/docs/en/slash-commands)
- [Hooks](https://code.claude.com/docs/en/hooks)

---

## 10. Adapting this to software projects

This repo uses `/decide` and `DR-NNN` because the domain is personal projects.
The software-world convention is `/adr` and `ADR-NNN` (Architecture Decision
Records) — identical mechanism, different name. For a code project you'd also
add:

- `docs/architecture/overview.md`, imported only if short
- path-scoped rules per area (`backend/**`, `mobile/**`)
- a `PreToolUse` hook hard-denying edits to genuinely dangerous paths
- build and test commands in `CLAUDE.md`
