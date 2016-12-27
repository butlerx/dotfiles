alias sshon="sudo systemctl start ssh"
alias sshoff="sudo systemctl stop ssh"
alias getip="ip addr | awk '/inet/ {print }'"
alias ll="ls -al"
alias pgr="ps -ef | grep"
alias apti="sudo apt install"
alias aptu="sudo apt update"
alias apts="apt-cache search"

function medGui () {
  cd /home/chip/roms
  folderpath=$(ls)
  system=$(eval zenity --list --column System $folderpath --width=480 --height=272)
  if [ "$?" -eq 1 ]; then
     echo "Cancelled."
  else
     cd $system
     files=$(ls -Q)
     rom=$(eval zenity --list --column "Roms" $files --width=480 --height=272)
     if [ "$?" -eq 1 ]; then
        echo "Cancelled."
     else
        mednafen -fs 1 "$rom"
     fi
  fi
}
