#!/usr/bin/env sh
# pets: symlink=~/.xinitrc

# merge in defaults and keymaps
[ -f ~/.dotfiles/Xresources ] && xrdb -merge -I"$HOME" ~/.dotfiles/Xresources
[ -f /etc/X11/xinit/.Xresources ] && xrdb -merge /etc/X11/xinit/.Xresources
[ -f /etc/X11/xinit/.Xmodmap ] && xmodmap /etc/X11/xinit/.Xmodmap
[ -f ~/.dotfiles/Xmodmap ] && xmodmap ~/.dotfiles/Xmodmap
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    # shellcheck disable=SC1091
    # shellcheck source=/etc/X11/xinit/xinitrc.d/*.sh
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

session=${1:-xfce}

case $session in
i3 | i3wm) exec i3 ;;
xfce | xfce4) exec startxfce4 ;;
# No known session, try to run it as command
*) exec "$1" ;;
esac
