# Dotfiles

**The commit messages are usless because they are all generated with
[`git yolo`](https://github.com/butlerx/dotfiles/blob/master/gitconfig#L11)**

My custom zsh, Vim, weechat and tmux setup. The tmux and weechat are standard
just with custom stylings and plugins enabled.

Managed with [pets-configurator](https://github.com/butlerx/pets-configurator) —
configuration directives are embedded as comments in the files themselves.

## Install

Requires [pets](https://github.com/butlerx/pets-configurator) 0.6 or newer
(`cargo install pets-configurator`). 0.6 is needed for the `npm:` package
directives used by the pi, eslint and prettier configs.

```bash
./install.sh
```

Or manually:

```bash
pets --conf-dir .dotfiles/
```

Use `--dry-run` to preview changes without applying:

```bash
pets --conf-dir .dotfiles/ --dry-run
```

Check for drift without changing anything, or list what is managed:

```bash
pets --conf-dir .dotfiles/ --check   # exits non-zero if out of sync
pets --conf-dir .dotfiles/ list      # managed files and their status
```

## Structure

- **Top-level dotfiles** — shell, git, tmux, ssh, X11 configs with inline
  `# pets` modeline comments
- **`config/`** — XDG application configs (nvim, ghostty, alacritty, i3, rofi,
  opencode, systemd units)
- **`zsh.d/`** — autoloaded zsh scripts
- **`zsh-completions/`** — custom zsh completions (including pets)
- **`fonts/`** — user fonts (`~/.local/share/fonts`)
- **`i3/`** — i3wm config, picom, lockscreen
- **`pi/`** — pi agent config (see below)

## Cross-platform

Linux-only configs (i3, XFCE, systemd, X11) are guarded with `when=os:linux` and
will be skipped on macOS. Packages specify multiple managers where applicable
(e.g. `package=yay:ghostty, package=homebrew:ghostty`). Cross-platform tooling
uses the `cargo:`, `pip:` and `npm:` prefixes, which work on either OS — eslint,
prettier, the neovim node provider and pi are all installed that way.

### NeoVIM

Uses Neovim's built-in `vim.pack` for plugin management. Plugins are configured
in `.dotfiles/config/nvim/lua/plugins.lua`.

### Zsh

These are a collection of custom zsh settings and fuctions. The theme
[Powerlevel9k](https://github.com/bhilburn/powerlevel9k) is used as a base with
custom layout. If powerlevel10k fails to install zsh falls back to a simpler
theme.

All `.zsh` files in `.dotfiles/zsh` are autoloaded

### Linting

`eslint.config.mjs` is a flat config for ESLint 10 and typescript-eslint 8. It
uses [`eslint-plugin-import-x`](https://github.com/un-ts/eslint-plugin-import-x)
rather than `eslint-plugin-import`, which still caps its peer range at ESLint 9.
Type-aware rules run through `projectService`, and plain JS files fall back to
`disableTypeChecked` so they lint without a tsconfig project.

ESLint resolves a config's plugins relative to the config file, not from the
global install, so the toolchain is pinned in this repo's `package.json` and
installed into `.dotfiles/node_modules` by `install.sh`. That is what makes
`eslint --config ~/.eslint.config.mjs` work from any project. Only the `eslint`
and `prettier` CLIs themselves are installed globally by pets.

### AI agents

**opencode** — `config/opencode/` is symlinked to `~/.config/opencode` as a
whole directory. Credentials and installed plugins (`antigravity-accounts.json`,
`node_modules`, lockfiles) live there untracked and are covered by
`config/opencode/.gitignore`.

**pi** — pi mixes config with sessions, caches and `auth.json` in `~/.pi/agent`,
so that directory is not symlinked wholesale. Instead:

- `pi/agents/`, `pi/skills/` and `pi/themes/` are directory symlinks driven by
  their `.petsfile`
- `pi/settings.json`, `pi/settings-extensions.json`, `pi/mcp.json` and
  `pi/AGENTS.md` are linked by `pi/link-config.sh`, which `install.sh` runs
  after pets. JSON and Markdown cannot carry a modeline comment, so pets cannot
  manage those four directly.
- `auth.json`, `sessions/`, `npm/`, `git/`, `cache/` and the theme caches stay
  untracked in `~/.pi/agent`

pi itself is installed by pets via `package=npm:@earendil-works/pi-coding-agent`
on `pi/agents/.petsfile`, so it needs pets 0.6 or newer.
