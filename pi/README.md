# pi

Config for the
[pi](https://www.npmjs.com/package/@earendil-works/pi-coding-agent) coding
agent. `pi/agent/` mirrors `~/.pi/agent/`.

pi keeps its config in the same directory as its sessions, caches and
`auth.json`, so the directory itself is never symlinked. Each managed entry is
linked individually:

| Source                           | Destination                            |
| -------------------------------- | -------------------------------------- |
| `agent/settings.json`            | `~/.pi/agent/settings.json`            |
| `agent/settings-extensions.json` | `~/.pi/agent/settings-extensions.json` |
| `agent/mcp.json`                 | `~/.pi/agent/mcp.json`                 |
| `agent/AGENTS.md`                | `~/.pi/agent/AGENTS.md`                |
| `agent/agents/`                  | `~/.pi/agent/agents`                   |
| `agent/skills/`                  | `~/.pi/agent/skills`                   |
| `agent/themes/`                  | `~/.pi/agent/themes`                   |

JSON and Markdown cannot carry a pets modeline, so those four use
`<name>.petsfile` sidecars. The three directories use a `.petsfile` inside them.

Everything else in `~/.pi/agent` stays untracked and local: `auth.json`,
`sessions/`, `npm/`, `git/`, `cache/` and the theme caches.

pi itself is installed by pets via `package=npm:@earendil-works/pi-coding-agent`
on `agent/agents/.petsfile`.

`agent/agents/` and `agent/skills/` are largely written by pi extensions, so
they change under you — expect churn in `git status` after installing or
updating one.
