# Dotfiles

**The commit messages are usless because they are all generated with
[`git yolo`](https://github.com/butlerx/dotfiles/blob/master/gitconfig#L11)**

My custom zsh, Vim, weechat and tmux setup. The tmux and weechat are standard
just with custom stylings and plugins enabled.

Managed with [pets-configurator](https://github.com/butlerx/pets-configurator) —
configuration directives are embedded as comments in the files themselves.

## Install

Requires [pets](https://github.com/butlerx/pets-configurator) (`cargo install pets-configurator`).

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

## Structure

- **Top-level dotfiles** — shell, git, tmux, ssh, X11 configs with inline `# pets:` directives
- **`config/`** — XDG application configs (nvim, ghostty, alacritty, i3, rofi, systemd units)
- **`zsh.d/`** — autoloaded zsh scripts
- **`zsh-completions/`** — custom zsh completions (including pets)
- **`fonts/`** — user fonts (`~/.local/share/fonts`)
- **`i3/`** — i3wm config, picom, lockscreen

## Cross-platform

Linux-only configs (i3, XFCE, systemd, X11) are guarded with `when=os:linux` and
will be skipped on macOS. Packages specify multiple managers where applicable
(e.g. `package=yay:ghostty, package=homebrew:ghostty`).

### NeoVIM

Uses Neovim's built-in `vim.pack` for plugin management. Plugins are configured
in `.dotfiles/config/nvim/lua/plugins.lua`.

### Zsh

These are a collection of custom zsh settings and fuctions. The theme
[Powerlevel9k](https://github.com/bhilburn/powerlevel9k) is used as a base with
custom layout. If powerlevel10k fails to install zsh falls back to a simpler
theme.

All `.zsh` files in `.dotfiles/zsh` are autoloaded
