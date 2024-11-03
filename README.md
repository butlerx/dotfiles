# Dotfiles

**The commit messages are usless because they are all generated with
[`git yolo`](https://github.com/butlerx/dotfiles/blob/master/gitconfig#L11)**

My custom zsh, Vim, weechat and tmux setup. The tmux and weechat are standard
just with custom stylings and plugins enabled.

### NeoVIM

It uses [Plug](https://github.com/junegunn/vim-plug) for Plugin managment. The
Plugins installed are set in the `.dotfiles/config/nvim/lua/plugins.lua` file.

### Zsh

These are a collection of custom zsh settings and fuctions. The theme
[Powerlevel9k](https://github.com/bhilburn/powerlevel9k) is used as a base with
custom layout. If powerlevel10k fails to install zsh falls back to a simpler
theme.

All `.zsh` files in `.dotfiles/zsh` are autoloaded

## Install

with [pets](https://github.com/butlerx/pets-configurator)

```bash
pets --conf-dir .dotfiles/
```
