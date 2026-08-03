# Projects

One folder per project, kebab-case. Nothing here yet.

Run `/project <name>` to start one — it asks what you're trying to change and
how you'll know it worked, then creates the folder and registers it in
`PROJECT_STATE.md`.

A project folder is whatever it needs to be — there's no required structure.
Common shape:

```
projects/sleep-schedule/
├── notes.md      # what this is, what "done" looks like
├── log.md        # dated entries, newest first, append-only
└── data/         # anything measured
```

Create the files you'll actually use. An empty `notes.md` is worse than no
`notes.md` — it costs context and teaches nothing.

If you create a folder by hand instead, add a line for it under **Active
projects** in `PROJECT_STATE.md` — nothing loads `projects/` automatically,
so an unregistered folder is invisible to future sessions.
