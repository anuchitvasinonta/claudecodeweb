# Personal projects

A git-backed working repo for personal life-improvement projects, set up so
that a new Claude Code session picks up where the last one left off.

## Why it's structured this way

Claude Code sessions start with a fresh context window every time — on web,
desktop, and CLI alike. Nothing carries over automatically between sessions.
So anything worth remembering is committed here instead.

Full reasoning and reference: **[docs/claude-code-project-brain.md](docs/claude-code-project-brain.md)**

## Layout

| Path | What it is |
| :--- | :--- |
| `CLAUDE.md` | Entry point. Loaded into every session. |
| `PROJECT_STATE.md` | Where things stand right now. Injected at session start. |
| `docs/decisions/` | Numbered decision records + the index Claude reads. |
| `docs/working/` | Open questions. |
| `projects/` | One folder per project. |
| `.claude/commands/` | `/start`, `/wrap`, `/decide` |
| `.claude/rules/` | Constraints scoped to matching file paths. |
| `.claude/hooks/` | Session-start context injection, path guards. |

## Using it

- **Start a session** — `PROJECT_STATE.md` is injected automatically. Run
  `/start` for a fuller read after a gap.
- **End a session** — run `/wrap`. This is the habit that keeps the repo
  useful; without it everything here goes stale.
- **Made a real decision?** — `/decide <title>`.

Run `/context` to confirm what actually loaded.
