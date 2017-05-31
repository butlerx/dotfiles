#!/bin/sh

# merge in defaults and keymaps
[[ -f ~/.dotfiles/Xresources ]] && xrdb -merge -I"$HOME" ~/.dotfiles/Xresources
[[ -f /etc/X11/xinit/.Xresources ]] && xrdb -merge /etc/X11/xinit/.Xresources
[[ -f /etc/X11/xinit/.Xmodmap ]] && xmodmap /etc/X11/xinit/.Xmodmap
[[ -f ~/.dotfiles/Xmodmap ]] && xmodmap ~/.dotfiles/Xmodmap
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
exec i3 >> ~/.i3/.i3log 2>&1
#exec sway
