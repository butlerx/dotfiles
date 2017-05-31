# -------------------------------------------------------------------
# compressed file expander
# (from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh)
# -------------------------------------------------------------------
ex() {
    if [[ -f $1 ]]; then
        case $1 in
          *.tar.bz2) tar xvjf "$1";;
          *.tar.gz) tar xvzf "$1";;
          *.tar.xz) tar xvJf "$1";;
          *.tar.lzma) tar --lzma xvf "$1";;
          *.bz2) bunzip "$1";;
          *.rar) unrar "$1";;
          *.gz) gunzip "$1";;
          *.tar) tar xvf "$1";;
          *.tbz2) tar xvjf "$1";;
          *.tgz) tar xvzf "$1";;
          *.zip) unzip "$1";;
          *.Z) uncompress "$1";;
          *.7z) 7z x "$1";;
          *.dmg) hdiutul mount "$1";; # mount OS X disk images
          *) echo "'$1' cannot be extracted via >ex<";;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -------------------------------------------------------------------
# any function from http://onethingwell.org/post/14669173541/any
# search for running processes
# -------------------------------------------------------------------
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}

# -------------------------------------------------------------------
# display a neatly formatted path
# -------------------------------------------------------------------
path() {
  echo "$PATH" | tr ":" "\n" | \
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
           sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
           sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
           sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
           sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
           print }"
}

# -------------------------------------------------------------------
# Mac specific functions
# -------------------------------------------------------------------
if [[ $IS_MAC -eq 1 ]]; then

    # view man pages in Preview
    pman() {
      ps=$(mktemp -t manpageXXXX).ps;
      man -t "$@" > "$ps";
      open "$ps";
    }

    # function to show interface IP assignments
    ips() {
      foo=$(/Users/mark/bin/getip.py; /Users/mark/bin/getip.py en0; /Users/mark/bin/getip.py en1);
      echo "$foo";
    }

    # notify function - http://hints.macworld.com/article.php?story=20120831112030251
    notify() {
      automator -D title="$1" -D subtitle="$2" -D message="$3" ~/Library/Workflows/DisplayNotification.wflow
    }
fi

# -------------------------------------------------------------------
# nice mount (http://catonmat.net/blog/another-ten-one-liners-from-commandlingfu-explained)
# displays mounted drive information in a nicely formatted manner
# -------------------------------------------------------------------
function nicemount() {
  (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2="";1') | column -t
}

# -------------------------------------------------------------------
# myIP address
# -------------------------------------------------------------------
function myip() {
  ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
  ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

# -------------------------------------------------------------------
# (s)ave or (i)nsert a directory.
# -------------------------------------------------------------------
s() { pwd > ~/.save_dir ; }
i() { cd "$(cat ~/.save_dir)" || return ; }

# -------------------------------------------------------------------
# console function
# -------------------------------------------------------------------
function console () {
  if [[ $# -gt 0 ]]; then
    query=$(echo "$*"|tr -s ' ' '|')
    tail -f /var/log/system.log | grep -i --color=auto -E "$query"
  else
    tail -f /var/log/system.log
  fi
}

# -------------------------------------------------------------------
# shell function to define words
# http://vikros.tumblr.com/post/23750050330/cute-little-function-time
# -------------------------------------------------------------------
givedef() {
  if [[ $# -ge 2 ]]; then
    echo "givedef: too many arguments" >&2
    return 1
  else
    curl "dict://dict.org/d:$1"
  fi
}

transfer() {
  #  check arguments
  if [ $# -eq 0 ]; then
    printf "No arguments specified. Usage:\n transfer /tmp/test.md\ncat /tmp/test.md | transfer"
    return 1
  fi
  # get temporarily filename, output is written to this file show progress can be showed
  file=$3
  while getopts ":e:" opt; do
    case $opt in
      e)
        encrypted=$( mktemp -t transferXXX )
        keybase encrypt -i "$file" "$OPTARG" >> "$encrypted"
        cat "$encrypted"
        send "$encrypted"
        rm -f "$encrypted"
        exit 0
        ;;
      \?)
        echo "Invalid option: -""$OPTARG" >&2
        exit 1
        ;;
      :)
        echo "Option -""$OPTARG" "requires an argument." >&2
        exit 1
        ;;
    esac
  done
  send "$encrypted"
}

send() {
  # upload stdin or file
  file=$1
  if tty -s; then
    basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
    if [ ! -e "$file" ]; then
      echo "File" "$file" "doesn't exists."
      return 1
    fi
    if [ -d "$file" ]; then
      # zip directory and transfer
      zipfile=$( mktemp -t transferXXX.zip )
      cd "$(dirname "$file")" && zip -r -q - "$(basename "$file")" >> "$zipfile"
      tmpfile=$( mktemp -t transferXXX )
      curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/""$basefile"".zip" >> "$tmpfile"
      rm -f "$zipfile"
    else
      # transfer file
      curl --progress-bar --upload-file "$file" "https://transfer.sh/""$basefile" >> "$tmpfile"
    fi
  else
    # transfer pipe
    curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> "$tmpfile"
  fi
  # cat output link
  cat "$tmpfile"
  # cleanup
  rm -f "$tmpfile"
  return 0
}

docker-ip () {
  docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}, {{end}}' "$@"
}

docker-clean () {
  docker rm -v $(docker ps -a -q -f status=exited) 2> /dev/null
  docker rmi $(docker images -f "dangling=true" -q) 2> /dev/null
  docker volume rm $(docker volume ls -qf dangling=true) 2> /dev/null
}

up () {
  LEVEL=$1
  for ((i = 1; i <= "$LEVEL"; i++)); do
    CDIR=../"$CDIR"
  done
  cd "$CDIR" || return
  echo "You are in:" "$PWD"
}

add () {
  a=$1; b=$2
  echo "$a" + "$b" = $((a + b))
}

sub () {
  a=$1; b=$2
  echo "$a" - "$b" = $((a - b))
}

mulp () {
  a=$1; b=$2
  echo "$a" "*" "$b" = $((a * b))
}

div () {
  a=$1; b=$2
  echo "$a" / "$b" = $((a / b))
}

armstrong () {
  n=$1; arm=0; temp="$n"
  while [ "$n" -ne 0 ]; do
    r=$((n % 10))
    arm=$((arm + r * r * r))
    n=$((n / 10))
  done
  if [ "$arm" -eq "$temp" ]; then
    echo "$temp" "is Armstrong"
  else
    echo "$temp" "Not Armstrong"
  fi
}

Binary2Decimal () {
  Binary=$1; re='^[0-9]+$';
  if ! [[ "$Binary" =~ $re ]]; then
    echo "Enter a valid number "
  else
    while [ "$Binary" -ne 0 ]; do
      Decimal=0
      power=1
      while [ "$Binary" -ne 0 ]; do
        rem=$((Binary % 10))
        Decimal=$((Decimal+(rem*power)))
        power=$((power*2))
        Binary=$((Binary / 10))
      done
      echo  "$Decimal"
    done
  fi
}

Decimal2Binary () {
  for ((i=32; i >= 0; i--)); do
    r=$(( 2**i))
    Probablity+=( $r  )
  done
  [[ $# -eq 0 ]] && { echo -e "Usage \n$0 numbers"; }
  for input_int in "$@"; do
    echo -en "Decimal\t\tBinary\n"
    s=0
    test ${#input_int} -gt 11 && { echo "Support Upto 10 Digit number :: skiping \"$input_int\""; continue; }
    printf "%-10s\t" "$input_int"
    for n in "${Probablity[@]}"; do
      if [[ $input_int -lt ${n} ]]; then
        [[ $s = 1 ]] && printf "%d" 0
      else
        printf "%d" 1 ; s=1
        input_int=$(( input_int - n ))
      fi
    done
  echo -e
  done
}

isprime () {
  n=$1; i=1; c=1;
  while [ $i -le "$n" ]; do
    i=$((i + 1))
    r=$((n % i))
    if [ $r -eq 0 ]; then
      c=$((c + 1))
    fi
  done
  if [ $c -eq 2 ]; then
    echo Prime
  else
    echo Not Prime
  fi
}

colour () {
  spam=$1
  clear
  echo -e "\033[1m" "$spam"
   # bold effect
  echo -e "\033[5m Blink"
         # blink effect
  echo -e "\033[0m" "$spam"
   # back to noraml
  echo -e "\033[31m" "$spam"
   # Red color
  echo -e "\033[32m" "$spam"
   # Green color
  echo -e "\033[33m" "$spam"
   # See remaing on screen
  echo -e "\033[34m" "$spam"
  echo -e "\033[35m" "$spam"
  echo -e "\033[36m" "$spam"
  echo -e -n "\033[0m"
    # back to noraml
  echo -e "\033[41m" "$spam"
  echo -e "\033[42m" "$spam"
  echo -e "\033[43m" "$spam"
  echo -e "\033[44m" "$spam"
  echo -e "\033[45m" "$spam"
  echo -e "\033[46m" "$spam"
  echo -e "\033[0m" "$spam"
}

lowercase () {
  fileName=$1
  if [ ! -f "$fileName" ]; then
    echo "Filename" "$fileName" "does not exists"
    exit 1
  fi
  tr '[:upper:]' '[:lower:]' < "$fileName" >> small.txt
}

diskUsed () {
  PART=nvme0n1p3
  USE=$(df -h |grep $PART | awk '{ print $5 }' | cut -d'%' -f1)
  echo "Percent used:" "$USE"
}

process () {
  echo "Hello" "$USER"
  echo "Hey i am" "$HOST" "and will be telling you about the current processes"
  echo "Running processes List"
  ps
}

specialPattern () {
  MAX_NO=$1
  if ! [ "$MAX_NO" -ge 5 ] && [ "$MAX_NO" -le 9 ] ; then
    echo "WTF... I ask to enter number between 5 and 9, Try Again"
  else
    clear
    for (( i=1; i<=MAX_NO; i++ )); do
      for (( s=MAX_NO; s>=i; s-- )); do
        echo -n " "
      done
      for (( j=1; j<=i;  j++ )); do
        echo -n " ."
      done
      echo ""
    done
    for (( i=MAX_NO; i>=1; i-- )); do
      for (( s=i; s<=MAX_NO; s++ )); do
        echo -n " "
      done
      for (( j=1; j<=i;  j++ )); do
        echo -n " ."
      done
      echo ""
    done
  fi
}

timeTable () {
  n=$1; i=1
  while [ $i -ne 10 ]; do
    i=$((i + 1))
    table=$(( i * n))
    echo "$table"
  done
}

health () {
  date;
  echo "uptime:"
  uptime
  echo "Currently connected:"
  w
  echo "--------------------"
  echo "Last logins:"
  last -a |head -3
  echo "--------------------"
  echo "Disk and memory usage:"
  df -h | xargs | awk '{print "Free/total disk: " $11 " / " $9}'
  free -m | xargs | awk '{print "Free/total memory: " $17 " / " $8 " MB"}'
  echo "--------------------"
  start_log=$(head -1 /var/log/messages |cut -c 1-12)
  oom=$(grep -ci kill /var/log/messages)
  echo -n "OOM errors since ""$start_log"" :" "$oom"
  echo ""
  echo "--------------------"
  echo "Utilization and most expensive processes:"
  top -b |head -3
  echo
  top -b |head -10 |tail -4
  echo "--------------------"
  echo "Open TCP ports:"
  nmap -p- -T4 127.0.0.1
  echo "--------------------"
  echo "Current connections:"
  ss -s
  echo "--------------------"
  echo "processes:"
  ps auxf --width=200
  echo "--------------------"
  echo "vmstat:"
  vmstat 1 5
}

encrypt () {
  file=$1;
  keybase encrypt -i "$file" -o "$file".keybase butlerx
  rm -rf "$file"
}

decrypt () {
  file=$1;
  keybase decrypt -i "$file"
}

gpgEncrypt () {
  file=$1;
  gpg -c "$file"
  rm -rf "$file"
}

gpgDecrypt () {
  file=$1;
  gpg -d "$file"
}

evenOdd () {
  num=$(( $1 % 2))
  if [ "$num" -eq 0 ]; then
    echo "is a Even Number"
  else
    echo "is a Odd Number"
  fi
}

simpleCalc () {
  clear
  sum=0
  i="y"; n1=$1; n2=$2;
  while [ $i = "y" ]; do
    echo "1.Addition"
    echo "2.Subtraction"
    echo "3.Multiplication"
    echo "4.Division"
    echo "Enter your choice"
    read -r ch
    case $ch in
      1)sum=$((n1 + n2))
        echo "Sum ="$sum;;
      2)sum=$((n1 - n2))
        echo "Sub = "$sum;;
      3)sum=$((n1 * n2))
        echo "Mul = "$sum;;
      4)sum=$((n1 / n2))
        echo "Div = "$sum;;
      *)echo "Invalid choice";;
    esac
    echo "Do u want to continue (y/n)) ?"
    read -r i
  done
}

fibonacci () {
  a=$1; fact=1
  while [ "$a" -ne 1 ]; do
    fact=$((fact * a))
    a=$((a - 1))
    echo "$fact"
  done
}

fractorial () {
  a=$1; fact=1
  while [ "$a" -ne 0 ]; do
    fact=$((fact * a))
    a=$((a - 1))
  done
  echo "$fact"
}
