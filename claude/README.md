# claude

Config for [Claude Code](https://claude.com/claude-code). `claude/` mirrors
`~/.claude/`.

Claude Code keeps its config in the same directory as its sessions, caches and
history, so the directory itself is never symlinked. Each managed entry is
linked individually:

| Source                | Destination                    |
| --------------------- | ------------------------------ |
| `settings.json`       | `~/.claude/settings.json`      |
| `CLAUDE.md`           | `~/.claude/CLAUDE.md`          |
| `statusline.sh`       | `~/.claude/statusline.sh`      |
| `skills/gh-stack/`    | `~/.claude/skills/gh-stack`    |
| `skills/incident/`    | `~/.claude/skills/incident`    |

JSON, Markdown and the shell script use `<name>.petsfile` sidecars. The skill
directories use a `.petsfile` inside them.

This repo is public, so `settings.json` must not hold work-specific detail. The
`autoMode` block lives in the relevant project's gitignored
`.claude/settings.local.json` instead.

Everything else in `~/.claude` stays untracked and local: `settings.local.json`,
`skills/synced/`, `plugins/`, `projects/`, `history.jsonl` and the caches.
