# Dotfiles

**The commit messages are usless because they are all generated with
[`git yolo`](https://github.com/butlerx/dotfiles/blob/master/gitconfig#L11)**

Zsh, Neovim, tmux, weechat and a handful of AI coding agents, deployed with
[pets-configurator](https://github.com/butlerx/pets-configurator).

## Layout

The repository mirrors `$HOME`, minus the leading dot. `zshrc` lands at
`~/.zshrc`, `config/nvim/` at `~/.config/nvim/`, `pi/agent/settings.json` at
`~/.pi/agent/settings.json`. If you want to know where a file ends up, read its
path.

Everything not deployed lives at the root: this README, `LICENSE`, `.pets.toml`,
the npm manifest, and the `powerlevel9k` submodule.

## Install

Requires [pets](https://github.com/butlerx/pets-configurator) 0.7 or newer for
the repository resources in `.pets.toml`:

```bash
cargo install pets-configurator
cd ~/.dotfiles
pets sync
```

`pets sync` initializes Git submodules, installs the npm toolchain when its
lockfile changes, generates the Zsh completion, and links every managed file.

```bash
pets --dry-run sync   # preview, with diffs
pets --check sync     # exit non-zero if anything drifted
pets list             # managed files and repository resources
```

Flags come before the subcommand; `pets sync --dry-run` is a parse error.

## How files are declared

| Mechanism                  | Used for                                               | Example                           |
| -------------------------- | ------------------------------------------------------ | --------------------------------- |
| Inline `# pets:` comment   | Anything that takes comments                           | `zshrc`                           |
| `.petsfile` in a directory | Symlinking a whole directory                           | `zsh.d/.petsfile`                 |
| `<name>.petsfile` sidecar  | JSON, Markdown, or a second destination for one source | `pi/agent/settings.json.petsfile` |
| `.pets.toml`               | Submodules, generated files, npm package set           | repository root                   |

The comment marker can be `#`, `;`, `//`, `--`, `"`, `!` or `%`, so each file
uses its own syntax. A directive must open the line.

## What goes where

### Shell

| Source             | Destination          | OS   |
| ------------------ | -------------------- | ---- |
| `zshrc`            | `~/.zshrc`           | both |
| `zsh.d/`           | `~/.zsh.d`           | both |
| `zsh-completions/` | `~/.zsh-completions` | both |

See [`zsh.d/README.md`](zsh.d/README.md). `powerlevel9k/` is a submodule sourced
directly from `~/.dotfiles` by `zsh.d/14-prompt.zsh`, not linked into `$HOME`.

### Editors and terminal

| Source                  | Destination                | OS   |
| ----------------------- | -------------------------- | ---- |
| `vimrc`                 | `~/.vimrc`                 | both |
| `config/nvim/`          | `~/.config/nvim`           | both |
| `tmux.conf`             | `~/.tmux.conf`             | both |
| `tmux/`                 | `~/.tmux`                  | both |
| `config/ghostty/config` | `~/.config/ghostty/config` | both |

See [`config/nvim/README.md`](config/nvim/README.md).

### Development

| Source              | Destination            | OS    |
| ------------------- | ---------------------- | ----- |
| `gitconfig`         | `~/.gitconfig`         | both  |
| `gitignore`         | `~/.gitignore`         | both  |
| `tombi.toml`        | `~/tombi.toml`         | both  |
| `yamlfmt.yaml`      | `~/.yamlfmt.yaml`      | both  |
| `ssh/config`        | `~/.ssh/config`        | both  |
| `eslint.config.mjs` | `~/.eslint.config.mjs` | both  |
| `prettierrc.mjs`    | `~/.prettierrc.mjs`    | both  |
| `flake8`            | `~/.flake8`            | linux |

### AI agents

| Source             | Destination               | OS   |
| ------------------ | ------------------------- | ---- |
| `config/opencode/` | `~/.config/opencode`      | both |
| `pi/agent/`        | `~/.pi/agent/` (per file) | both |

See [`pi/README.md`](pi/README.md).

### Desktop (Linux only)

| Source                                         | Destination                                |
| ---------------------------------------------- | ------------------------------------------ |
| `config/i3/config`                             | `~/.config/i3/config`                      |
| `config/picom/picom.conf`                      | `~/.config/picom/picom.conf`               |
| `config/polybar/config.ini`                    | `~/.config/polybar/config.ini`             |
| `config/rofi/`                                 | `~/.config/rofi`                           |
| `config/autorandr/`                            | `~/.config/autorandr`                      |
| `config/autostart/`                            | `~/.config/autostart`                      |
| `config/systemd/user/ssh-agent.service`        | `~/.config/systemd/user/ssh-agent.service` |
| `config/libinput-gestures.conf`                | `~/.config/libinput-gestures.conf`         |
| `Xresources` `Xmodmap` `xinitrc` `xbindkeysrc` | `~/.Xresources` etc.                       |
| `gtkrc-3.0`                                    | `~/.gtkrc-3.0`                             |
| `themes/`                                      | `~/.themes`                                |
| `local/share/fonts/`                           | `~/.local/share/fonts`                     |

`config/i3/workspace-*.json` are i3 layout snapshots, restored by hand; they are
not deployed. On macOS all of the above are skipped by `when=os:linux` —
including the fonts, since macOS reads user fonts from `~/Library/Fonts`.

### Other

| Source                             | Destination                   | OS   |
| ---------------------------------- | ----------------------------- | ---- |
| `mozilla/firefox/butlerx.default/` | Firefox profile, per platform | both |
| `weechat/`                         | `~/.weechat`                  | both |

See [`mozilla/README.md`](mozilla/README.md) and
[`weechat/README.md`](weechat/README.md).

## Cross-platform

Linux-only files are guarded with `when=os:linux` and skipped everywhere else;
`pets list` omits them entirely on macOS. Packages name several managers where
they differ (`package=yay:ghostty, package=homebrew:ghostty`), and
cross-platform tooling uses the `cargo:`, `pip:` and `npm:` prefixes.

## Linting

`eslint.config.mjs` is a flat config for ESLint 10 and typescript-eslint 8. It
uses [`eslint-plugin-import-x`](https://github.com/un-ts/eslint-plugin-import-x)
rather than `eslint-plugin-import`, which still caps its peer range at ESLint 9.
Type-aware rules run through `projectService`, and plain JS files fall back to
`disableTypeChecked` so they lint without a tsconfig project.

ESLint resolves a config's plugins relative to the config file, not from the
global install, so the toolchain is pinned in `package.json` and installed into
`node_modules/` by the npm package set in `.pets.toml`. That is what makes
`eslint --config ~/.eslint.config.mjs` work from any project. Only the `eslint`
and `prettier` CLIs themselves are installed globally by pets.

Both configs are ESM (`.mjs`) and the repo is `"type": "module"`.
