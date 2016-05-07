# checks (stolen from zshuery)
if [[ $(uname) = 'Linux' ]]; then
  IS_LINUX=1
fi

if [[ $(uname) = 'Darwin' ]]; then
  IS_MAC=1
fi

if [[ -x `which dnf` ]]; then
  HAS_YUM=1
fi
