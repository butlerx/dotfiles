# Dotfiles
I custom zsh, Vim, weechat and tmux setup.

The tmux and weechat are standard just with custom stylings and plugins enabled.

### VIM
The Vim config is compatible with Vim and NeoVim.  
It uses [Plug](https://github.com/junegunn/vim-plug) for Plugin managment. The
Plugins installed are set in the `.dotfiles/vimrc.d/vim.plug` file.  
The Config is loaded sourced for `.dotfiles/vimrc.d`. All `.vim` files in this
folder are auto loaded.

### Zsh
These are a collection of custom zsh settings and fuctions. The theme
[Powerlevel9k](https://github.com/bhilburn/powerlevel9k) is used as a base with
custom layout. If powerlevel9k fails to install zsh falls back to a simpler
theme.

All `.zsh` files in `.dotfiles/zsh` are autoloaded

### Git

The Setup script will prompt you for git name and email to setup the global git
config.

## Install

```
curl https://raw.githubusercontent.com/butlerx/dotfiles/master/setup.sh | bash
```
