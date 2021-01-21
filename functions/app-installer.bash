#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : app-installer.bash
# @Created     : Wed, Aug 05, 2020, 02:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : installer functions for apps
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

TMPPATH="$HOME/.local/share/bash/basher/cellar/bin:$HOME/.local/share/bash/basher/bin:"
TMPPATH+="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/gem/bin:/usr/local/bin:"
TMPPATH+="/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:.:$PATH"

APPNAME="${APPNAME:-app-installer}"

set -o pipefail
trap '' ERR EXIT

export PATH="$(echo $TMPPATH | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:.#g')"
export SUDO_PROMPT="$(printf "\n\t\t\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m")"
export TMP="${TMP:-/tmp}"
export TEMP="${TEMP:-/tmp}"

export WHOAMI="${SUDO_USER:-$USER}"
export HOME="${USER_HOME:-$HOME}"
export LOGDIR="${LOGDIR:-$HOME/.local/log}"

sudo_root() {
  local SUDOBIN="$(command -v sudo)"
  local SUDOARG="-HE"
  $SUDOBIN $SUDOARG "$@"
}

sudo_user() {
  local SUDOBIN="$(command -v sudo)"
  local SUDOARG="-HE -u $USER"
  $SUDOBIN $SUDOARG "$@"
}

sudo_pkmgr() {
  local PKMGRBIN="$(command -v pkmgr)"
  local SUDOBIN="$(command -v sudo)"
  local SUDOARG="-HE -u $USER"
  $SUDOBIN $SUDOARG $PKMGRBIN "$@"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cmd_exists() {
  local pkg LISTARRAY
  declare -a LISTARRAY="$*"
  for cmd in $LISTARRAY; do
    type -P "$1" | grep -q "/" 2>/dev/null
  done
}

devnull() { "$@" >/dev/null 2>&1; }
devnull2() { "$@" >/dev/null 2>&1; }

# fail if git is not installed

if ! command -v "git" >/dev/null 2>&1; then
  echo -e "\t\t\033[0;31mAttempting to install git\033[0m"
  if cmd_exists brew; then
    brew install -f git >/dev/null 2>&1
  elif cmd_exists apt; then
    apt install -yy -q git >/dev/null 2>&1
  elif cmd_exists pacman; then
    pacman -S --noconfirm git >/dev/null 2>&1
  elif cmd_exists yum; then
    yum install -yy -q git >/dev/null 2>&1
  elif cmd_exists choco; then
    choco install git -y >/dev/null 2>&1
    if ! command -v git >/dev/null 2>&1; then
      echo -e "\t\t\033[0;31mGit was not installed\033[0m"
      exit 1
    fi
  else
    echo -e "\t\t\033[0;31mGit is not installed\033[0m"
    exit 1
  fi
fi

##################################################################################################

# Set Main Repo for dotfiles
export DOTFILESREPO="${DOTFILESREPO:-https://github.com/dfmgr}"

# Set other Repos
export DFMGRREPO="${DFMGRREPO:-https://github.com/dfmgr}"
export PKMGRREPO="${PKMGRREPO:-https://github.com/pkmgr}"
export DEVENVMGRREPO="${DEVENVMGR:-https://github.com/devenvmgr}"
export ICONMGRREPO="${ICONMGRREPO:-https://github.com/iconmgr}"
export FONTMGRREPO="${FONTMGRREPO:-https://github.com/fontmgr}"
export THEMEMGRREPO="${THEMEMGRREPO:-https://github.com/thememgr}"
export SYSTEMMGRREPO="${SYSTEMMGRREPO:-https://github.com/systemmgr}"
export WALLPAPERMGRREPO="${WALLPAPERMGRREPO:-https://github.com/wallpapermgr}"

##################################################################################################

NC="$(tput sgr0 2>/dev/null)"
RESET="$(tput sgr0 2>/dev/null)"
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"
ORANGE="\033[0;33m"
LIGHTRED='\033[1;31m'
BG_GREEN="\[$(tput setab 2 2>/dev/null)\]"
BG_RED="\[$(tput setab 9 2>/dev/null)\]"
ICON_INFO="[ ℹ️ ]"
ICON_GOOD="[ ✔ ]"
ICON_WARN="[ ❗ ]"
ICON_ERROR="[ ✖ ]"
ICON_QUESTION="[ ❓ ]"

##################################################################################################

printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
printf_normal() { printf_color "\t\t$1\n" "$2"; }
printf_green() { printf_color "$1" 2; }
printf_red() { printf_color "$1" 1; }
printf_purple() { printf_color "$1" 5; }
printf_yellow() { printf_color "$1" 3; }
printf_blue() { printf_color "$1" 4; }
printf_cyan() { printf_color "$1" 6; }
printf_info() { printf_color "\t\t$ICON_INFO $1\n" 3; }
printf_exit() {
  printf_color "\t\t$1\n" 1
  exit $?
}
printf_help() {
  printf_color "\t\t$1\n" 1
  exit $?
}
printf_read() { printf_color "\t\t$1" 5; }
printf_success() { printf_color "\t\t$ICON_GOOD $1\n" 2; }
printf_error() { printf_color "\t\t$ICON_ERROR $1 $2\n" 1; }
printf_warning() { printf_color "\t\t$ICON_WARN $1\n" 3; }
printf_error_stream() { while read -r line; do printf_error "? ERROR: $line"; done; }
printf_execute_success() { printf_color "\t\t$ICON_GOOD $1\n" 2; }
printf_execute_error() { printf_color "\t\t$ICON_WARN $1 $2\n" 1; }
printf_execute_result() {
  if [ "$1" -eq 0 ]; then
    printf_execute_success "$2"
  else
    printf_execute_error "$2"
  fi
  return "$1"
}
printf_execute_error_stream() { while read -r line; do printf_execute_error "? ERROR: $line"; done; }

##################################################################################################
printf_question() {
  history -s
  printf_color "\t\t$ICON_QUESTION $1 " 6
}

printf_readline() {
  $(set -o pipefail)
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="3"
  while read line; do
    printf_custom "$color" "$line"
  done
  $(set +o pipefail)
}

##################################################################################################

printf_custom() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  echo ""
}

##################################################################################################

printf_custom_input() {
  local color="1"
  local msg="$1"
  shift
  read -e -p
}

##################################################################################################

printf_custom_question() {
  local custom_question
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg " "$color"
}

##################################################################################################

printf_question_timeout() {
  local custom_question
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg " "$color"
  read -t 10 -n 1 answer && echo ""
  #if [[ $answer == "y" || $answer == "Y" ]]; then
  #fi
}

##################################################################################################

printf_head() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  local msg="$*"
  shift
  printf_color "
\t\t##################################################
\t\t$msg
\t\t##################################################\n\n" "$color"
}

##################################################################################################

printf_result() {
  [ ! -z "$1" ] && EXIT="$1" || EXIT="$?"
  [ ! -z "$2" ] && local OK="$2" || local OK="Command executed successfully"
  [ ! -z "$2" ] && local FAIL="$2" || local FAIL="Last command failed"
  if [ "$EXIT" -eq 0 ]; then
    printf_success "$OK"
    exit 0
  else
    printf_error "$FAIL"
    exit 1
  fi
}

##################################################################################################
get_answer() { printf "%s" "$REPLY"; }
answer_is_yes() { [[ "$REPLY" =~ ^[Yy]$ ]] && return 0 || return 1; }

ask_for_input() {
  history -s
  printf_question "$1"
  read -re "REPLY"
}

ask_question() {
  printf_question "$1 (y/n) "
  read -re -n 1 "REPLY"
}

##################################################################################################

notifications() {
  local title="$1"
  shift 1
  local msg="$*"
  shift
  cmd_exists notify-send && notify-send -u normal -i "notification-message-IM" "$title" "$msg" || return 0
}

##################################################################################################
__curl() { __am_i_online && curl --disable -LSs --connect-timeout 3 --retry 0 "$@"; }
__appversion() { __curl "${1:-REPORAW/master/version.txt}" || echo 011920210931-git; }

die() { echo -e "$1" exit ${2:9999}; }
killpid() { devnull kill -9 "$(pidof "$1")"; }
hostname2ip() { getent hosts "$1" | cut -d' ' -f1 | head -n1; }
set_trap() { trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"; }
getuser() { [ -z "$1" ] && cut -d: -f1 /etc/passwd | grep "$USER" || cut -d: -f1 /etc/passwd | grep "$1"; }

system_service_exists() {
  for service in "$@"; do
    if sudo systemctl list-units --full -all | grep -Fq "$1"; then return 0; else return 1; fi
  done
  setexitstatus
  set --
}

system_service_enable() {
  run_systemctl() {
    for service in "$@"; do
      sudo systemctl enable -f $service" "Enabling service: $1 || return 1
    done
  }
  if system_service_exists "$@"; then
    execute "run_systemctl $*" "Enabling service: $1"
  fi
  setexitstatus
  set --
}

system_service_disable() {
  run_systemctl() {
    for service in "$@"; do
      sudo systemctl disable --now $service || return 1
    done
  }
  if system_service_exists "$@"; then
    execute "run_systemctl $*" "Disabling service: $1"
  fi
  setexitstatus
  set --
}

run_post() {
  local e="$1"
  local m="${e//devnull//}"
  #local m="$(echo $1 | sed 's#devnull ##g')"
  execute "$e" "executing: $m"
  setexitstatus
  set --
}

##################################################################################################

#transmission-remote-cli() { cmd_exists transmission-remote-cli || cmd_exists transmission-remote ;}
mlocate() { cmd_exists locate || cmd_exists mlocate || return 1; }
xfce4() { cmd_exists xfce4-about || return 1; }
imagemagick() { cmd_exists convert || return 1; }
fdfind() { cmd_exists fdind || cmd_exists fd || return 1; }
speedtest() { cmd_exists speedtest-cli || cmd_exists speedtest || return 1; }
neovim() { cmd_exists nvim || cmd_exists neovim || return 1; }
chromium() { cmd_exists chromium || cmd_exists chromium-browser || return 1; }
firefox() { cmd_exists firefox-esr || cmd_exists firefox || return 1; }
gtk-2.0() { find /lib* /usr* -iname "*libgtk*2*.so*" -type f | grep -q . || return 0; }
gtk-3.0() { find /lib* /usr* -iname "*libgtk*3*.so*" -type f | grep -q . || return 0; }

export -f mlocate xfce4 imagemagick fdfind speedtest neovim chromium firefox gtk-2.0 gtk-3.0

##################################################################################################

backupapp() {
  local filename count backupdir rmpre4vbackup
  [ ! -z "$1" ] && local myappdir="$1" || local myappdir="$APPDIR"
  [ ! -z "$2" ] && local myappname="$2" || local myappname="$APPNAME"
  local downloaddir="$DOWNLOADED_TO"
  local logdir="$HOME/.local/log/backupapp"
  local curdate="$(date +%Y-%m-%d-%H-%M-%S)"
  local filename="$myappname-$curdate.tar.gz"
  local backupdir="${MY_BACKUP_DIR:-$HOME/.local/backups/$SCRIPTS_PREFIX}"
  local count="$(ls $backupdir/$myappname*.tar.gz 2>/dev/null | wc -l 2>/dev/null)"
  local rmpre4vbackup="$(ls $backupdir/$myappname*.tar.gz 2>/dev/null | head -n 1)"
  mkdir -p "$backupdir" "$logdir"
  if [ -d "$myappdir" ] && [ "$myappdir" != "$downloaddir" ] && [ ! -f "$APPDIR/.installed" ]; then
    echo -e " #################################" >>"$logdir/$myappname.log"
    echo -e "# Started on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    echo -e "# Backing up $myappdir" >>"$logdir/$myappname.log"
    echo -e "#################################\n" >>"$logdir/$myappname.log"
    tar cfzv "$backupdir/$filename" "$myappdir" >>"$logdir/$myappname.log" 2>>"$logdir/$myappname.log"
    echo -e "\n#################################" >>"$logdir/$myappname.log"
    echo -e "# Ended on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    echo -e "#################################\n\n" >>"$logdir/$myappname.log"
    rm_rf "$myappdir"
  fi
  if [ "$count" -gt "3" ]; then rm_rf $rmpre4vbackup; fi
}

##################################################################################################

broken_symlinks() { devnull find "$@" -xtype l -exec rm {} \;; }
rm_rf() { if [ -e "$1" ]; then devnull rm -Rf "$@"; else return 0; fi; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; else return 0; fi; }
ln_rm() { devnull find "$1" -xtype l -delete || return 0; }
ln_sf() {
  [ -L "$2" ] && rm_rf "$2"
  devnull ln -sf "$@" || return 0
}
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; else return 0; fi; }
mkd() { if [ ! -e "$1" ]; then devnull mkdir -p "$@"; else return 0; fi; }
replace() { find "$1" -not -path "$1/.git/*" -type f -exec sed -i "s#$2#$3#g" {} \; >/dev/null 2>&1; }
rmcomments() { sed 's/[[:space:]]*#.*//;/^[[:space:]]*$/d'; }
countwd() { cat "$@" | wc-l | rmcomments; }
urlcheck() { devnull __curl--config /dev/null --connect-timeout 3 --retry 3 --retry-delay 1 --output /dev/null --silent --head --fail "$1"; }
urlinvalid() { if [ -z "$1" ]; then
  printf_red "\t\tInvalid URL\n"
  failexitcode
else
  printf_red "\t\tCan't find $1\n"
  failexitcode
fi; }
urlverify() { urlcheck "$1" || urlinvalid "$1"; }
symlink() { ln_sf "$1" "$2"; }

##################################################################################################
__am_i_online() {
  site="1.1.1.1"
  test_ping() {
    timeout 1 ping -c1 $site &>/dev/null
    pingExit=$?
  }
  test_http() {
    timeout 1 __curl--disable -LSIs --max-time 1 $site | grep -e "HTTP/[0123456789]" | grep "200" -n1 &>/dev/null
    httpExit=$?
  }
  test_ping || test_http

  if [ "$pingExit" = 0 ] || [ "$httpExit" = 0 ]; then
    __AM_I_ONLINE=0
  else
    __AM_I_ONLINE=1
  fi
  export __AM_I_ONLINE
  return $__AM_I_ONLINE
}
##################################################################################################

cmd_exists() {
  local args="$*"
  for cmd in $args; do
    unalias "$cmd" 2>/dev/null >&1
    if devnull command -v "$cmd"; then return 0; else return 1; fi
    exitCode+=$?
  done
  exit $exitCode
}

gem_exists() {
  local package="$1"
  if devnull gem query -i -n "$package"; then return 0; else return 1; fi
}

perl_exists() {
  local package="$1"
  if devnull perl -M$package -le 'print $INC{"$package/Version.pm"}' || devnull perl -M$package -le 'print $INC{"$package.pm"}' || devnull perl -M$package -le 'print $INC{"$package"}'; then
    return 0
  else
    return 1
  fi
}

pthon_exists() {
  local package="$1"
  if devnull $PYTHONVER -c "import $package"; then return 0; else return 1; fi
}

##################################################################################################

retry_cmd() {
  retries="${1:-}"
  shift
  count=0
  until "$@"; do
    exit=$?
    wait=$((2 ** count))
    count=$((count + 1))
    if [ "$count" -lt "$retries" ]; then
      echo "Retry $count/$retries exited $exit, retrying in $wait seconds ..."
      sleep $wait
    else
      echo "Retry $count/$retries exited $exit, no more retries left."
      exit $exit
    fi
  done
}

##################################################################################################

returnexitcode() {
  local RETVAL="$?"
  EXIT="$RETVAL"
  if [ "$RETVAL" -ne 0 ]; then
    return "$EXIT"
  fi
}

##################################################################################################

getexitcode() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local RETVAL="$?"
  local ERROR="Setup failed"
  local SUCCES="$2"
  EXIT="$RETVAL"
  if [ "$RETVAL" -eq 0 ]; then
    printf_success "$SUCCES"
  else
    printf_error "$ERROR"
    exit "$EXIT"
  fi
}

##################################################################################################

failexitcode() {
  local RETVAL="$?"
  [ ! -z "$1" ] && local fail="$1" || local fail="Command has failed"
  [ ! -z "$2" ] && local success="$2" || local success=""
  if [ "$RETVAL" -ne 0 ]; then
    set -eE
    printf_error "$fail"
    exit 1
  else
    set +eE
    [ -z "$success" ] || printf_custom "42" "$success"
  fi
}

##################################################################################################

setexitstatus() {
  [ -z "$EXIT" ] && local EXIT="$?" || local EXIT="$EXIT"
  local EXITSTATUS+="$EXIT"
  if [ -z "$EXITSTATUS" ] || [ "$EXITSTATUS" -ne 0 ]; then
    BG_EXIT="${BG_RED}"
    return 1
  else
    BG_EXIT="${BG_GREEN}"
    return 0
  fi
}

##################################################################################################

__getip() {
  if cmd_exists route || cmd_exists ip; then
    if [[ "$OSTYPE" =~ ^darwin ]]; then
      NETDEV="$(route get default | grep interface | awk '{print $2}')"
    else
      NETDEV="$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//" | awk '{print $1}')"
    fi
    if cmd_exists ifconfig; then
      CURRIP4="$(/sbin/ifconfig $NETDEV | grep -E "venet|inet" | grep -v "127.0.0." | grep 'inet' | grep -v inet6 | awk '{print $2}' | sed s/addr://g | head -n1)"
      CURRIP6="$(/sbin/ifconfig "$NETDEV" | grep -E "venet|inet" | grep 'inet6' | grep -i global | awk '{print $2}' | head -n1)"
    else
      CURRIP4="$(ip addr | grep inet | grep -vE "127|inet6" | tr '/' ' ' | awk '{print $2}' | head -n 1)"
      CURRIP6="$(ip addr | grep inet6 | grep -v "::1/" -v | tr '/' ' ' | awk '{print $2}' | head -n 1)"
    fi
  else
    NETDEV="lo"
    CURRIP4="127.0.0.1"
    CURRIP6="::1"
  fi
}
__getip

##################################################################################################

__getpythonver() {
  if [[ "$(python3 -V 2>/dev/null)" =~ "Python 3" ]]; then
    PYTHONVER="python3"
    PIP="pip3"
    PATH="${PATH}:$(python3 -c 'import site; print(site.USER_BASE)')/bin"
  elif [[ "$(python2 -V 2>/dev/null)" =~ "Python 2" ]]; then
    PYTHONVER="python"
    PIP="pip"
    PATH="${PATH}:$(python -c 'import site; print(site.USER_BASE)')/bin"
  fi
  if [ "$(cmd_exists yay)" ] || [ "$(cmd_exists pacman)" ]; then PYTHONVER="python" && PIP="pip3"; fi
}
__getpythonver

##################################################################################################

__getphpver() {
  if cmd_exists php; then
    PHPVER="$(php -v | grep --only-matching --perl-regexp "(PHP )\d+\.\\d+\.\\d+" | cut -c 5-7)"
  else
    PHPVER=""
  fi
  echo $PHPVER
}

##################################################################################################

sudoif() { (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; }
sudorun() { if sudoif; then sudo "$@"; else "$@"; fi; }
sudorerun() {
  local ARGS="$ARGS"
  if [[ $UID != 0 ]]; then if sudoif; then sudo "$APPNAME" "$ARGS" && exit $?; else sudoreq; fi; fi
}
sudoreq() { if [[ $UID != 0 ]]; then
  echo "" && printf_error "Please run this script with sudo"
  returnexitcode
  exit 1
fi; }

######################

can_i_sudo() {
  (
    ISINDSUDO=$(sudo grep -Re "$MYUSER" /etc/sudoers* | grep "ALL" >/dev/null)
    sudo -vn && sudo -ln
  ) 2>&1 | grep -v 'may not' >/dev/null
}

######################

sudoask() {
  if [ ! -f "$HOME/.sudo" ]; then
    sudo true &>/dev/null
    while true; do
      echo -e "$!" >"$HOME/.sudo"
      sudo -n true && echo -e "$$" >>"$HOME/.sudo"
      sleep 10
      rm -Rf "$HOME/.sudo"
      kill -0 "$$" || return
    done &>/dev/null &
  fi
}

######################

sudoexit() {
  if [ $? -eq 0 ]; then
    sudoask || printf_green "\t\tGetting privileges successfull continuing\n" &&
      sudo -n true
  else
    printf_red "\t\tFailed to get privileges\n"
  fi
}

######################

requiresudo() {
  if [ -f "$(command -v sudo 2>/dev/null)" ]; then
    if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
      sudoask
      sudoexit && sudo "$@"
    fi
  else
    printf_red "\t\tYou dont have access to sudo\n\t\tPlease contact the syadmin for access\n"
    exit 1
  fi
}

##################################################################################################

addtocrontab() {
  [ "$1" = "--help" ] && printf_help 'addtocrontab "frequency" "command" | IE: addtocrontab "0 4 * * *" "echo hello"'
  local frequency="$1"
  local command="$2"
  local additional="$3"
  local job="$frequency $command $additional"
  cat <(grep -F -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -
}

crontab_add() {
  local appname="${APPNAME:-$1}"
  local action="${action:-$1}"
  local file="${file:-$appname}"
  local frequency="${frequency:-0 4 * * *}"
  case "$action" in
  remove)
    shift 1
    if [[ $EUID -ne 0 ]]; then
      printf_green "\t\tRemoving $file from $WHOAMI crontab\n"
      crontab -l | grep -v -F "$file" | crontab -
      printf_custom "2" "$file has been removed from automatically updating\n"
    else
      printf_green "\t\tRemoving $file from root crontab\n"
      sudo crontab -l | grep -v -F "$file" | sudo crontab -
      printf_custom "2" "$file has been removed from automatically updating\n"
    fi
    ;;

  add)
    shift 1
    if [[ $EUID -ne 0 ]]; then
      local croncmd="logr"
      local additional='bash -c "am_i_online && sleep $(expr $RANDOM \% 300) && '$APPDIR'/install.sh &"'
      printf_green "\t\tAdding $frequency $croncmd $additional to $WHOAMI crontab\n"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove\n"
    else
      local croncmd="logr"
      local additional='bash -c "am_i_online && sleep $(expr $RANDOM \% 300) && '$APPDIR'/install.sh &"'
      printf_green "\t\tAdding $frequency $croncmd $additional to root crontab\n"
      sudo crontab -l | grep -qv -F "$croncmd"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove\n"
    fi
    ;;

  *)
    if [[ $EUID -ne 0 ]]; then
      local croncmd="logr"
      local additional='bash -c "am_i_online && sleep $(expr $RANDOM \% 300) && '$APPDIR'/install.sh &"'
      printf_green "\t\tAdding $frequency $croncmd $additional to $WHOAMI crontab\n"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove\n"
    else
      local croncmd="logr"
      local additional='bash -c "am_i_online && sleep $(expr $RANDOM \% 300) && '$APPDIR'/install.sh &"'
      printf_green "\t\tAdding $frequency $croncmd $additional to root crontab\n"
      sudo crontab -l | grep -qv -F "$croncmd"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove\n"
    fi
    ;;
  esac
}

##################################################################################################

versioncheck() {
  if [ -f $APPDIR/version.txt ]; then
    printf_green "\t\tChecking for updates\n"
    local NEWVERSION="$(echo $APPVERSION | grep -v "#" | tail -n 1)"
    local OLDVERSION="$(cat $APPDIR/version.txt | grep -v "#" | tail -n 1)"
    if [ "$NEWVERSION" == "$OLDVERSION" ]; then
      printf_green "\t\tNo updates available current\n\t\tversion is $OLDVERSION\n"
    else
      printf_blue "\t\tThere is an update available\n"
      printf_blue "\t\tNew version is $NEWVERSION and current\n\t\tversion is $OLDVERSION\n"
      printf_question "Would you like to update" [y/N]
      read -n 1 -s choice
      echo ""
      if [[ $choice == "y" || $choice == "Y" ]]; then
        [ -f "$APPDIR/install.sh" ] && bash -c "$APPDIR/install.sh" && echo ||
          cd $APPDIR && git pull -q &&
          printf_green "\t\tUpdated to $NEWVERSION\n" ||
          printf_red "\t\tFailed to update\n"
      else
        printf_cyan "\t\tYou decided not to update\n"
      fi
    fi
  fi
  exit $?
}

##################################################################################################

scripts_check() {
  if __am_i_online; then
    if ! cmd_exists "pkmgr" && [ ! -f ~/.noscripts ]; then
      printf_red "\t\tPlease install my scripts repo - requires root/sudo\n"
      printf_question "Would you like to do that now" [y/N]
      read -n 1 -s choice && echo ""
      if [[ $choice == "y" || $choice == "Y" ]]; then
        urlverify $REPO/scripts/raw/master/install.sh &&
          sudo bash -c "$(__curl $REPO/installer/raw/master/install.sh)" && echo
      else
        touch ~/.noscripts
        exit 1
      fi
    fi
  fi
}

##################################################################################################

#is_url() { echo "$1" | grep -q http; }
#strip_url() { echo "$1" | sed 's#git+##g' | awk -F//*/ '{print $2}' | sed 's#.*./##g' | sed 's#python-##g'; }

cmd_missing() { cmd_exists "$1" && return 0 || MISSING+="$1 " && return 1; }
cpan_missing() { perl_exists "$1" && return 0 || MISSING+="$1" && return 1; }
gem_missing() { gem_exists "$1" && return 0 || MISSING+="$1 " && return 1; }
perl_missing() { perl_exists "$1" && return 0 || MISSING+="$(echo perl-$1 | sed 's#::#-#g') " && return 1; }
pip_missing() { pthon_exists "$1" && return 0 || MISSING+="$1 " && return 1; }

if cmd_exists pacman; then
  python_missing() { pthon_exists "$1" && return 0 || MISSING+="python-$1 " && return 1; }
else
  python_missing() { pthon_exists "$1" && return 0 || MISSING+="$PYTHONVER-$1 " && return 1; }
fi

##################################################################################################

git_clone() {
  if __am_i_online; then
    local repo="$1"
    [ ! -z "$2" ] && local myappdir="$2" || local myappdir="$APPDIR"
    [ ! -d "$myappdir" ] || rm_rf "$myappdir"
    devnull git clone --depth=1 -q --recursive "$@"
  fi
}

##################################################################################################

git_update() {
  if __am_i_online; then
    cd "$APPDIR" || exit 1
    local repo="$(git remote -v | grep fetch | head -n 1 | awk '{print $2}')"
    devnull git reset --hard &&
      devnull git pull --recurse-submodules -fq &&
      devnull git submodule update --init --recursive -q &&
      devnull git reset --hard -q
    if [ "$?" -ne "0" ]; then
      cd "$HOME" || exit 1
      git_clone "$repo" "$APPDIR"
    fi
  fi
}

##################################################################################################

dotfilesreqcmd() {
  if __am_i_online; then
    local gitrepo="$REPO"
    urlverify "$gitrepo/$conf/raw/master/install.sh" &&
      bash -c "$(__curl $gitrepo/$conf/raw/master/install.sh)" || return 1
  fi
}

dotfilesreqadmincmd() {
  if __am_i_online; then
    local gitrepo="$REPO"
    urlverify "$gitrepo/$conf/raw/master/install.sh" &&
      sudo bash -c "$(__curl $gitrepo/$conf/raw/master/install.sh)" || return 1
  fi
}

##################################################################################################

dotfilesreq() {
  if __am_i_online; then
    if cmd_exists pkmgr; then
      local confdir="$USRUPDATEDIR"
      declare -a LISTARRAY="$*"
      for conf in ${LISTARRAY[*]}; do
        if [ ! -f "$confdir/$conf" ] && [ ! -f "$TEMP/$conf.inst.tmp" ]; then
          execute \
            "dotfilesreqcmd" \
            "Installing required dotfile $conf"
        fi
      done
      rm_rf $TEMP/*.inst.tmp
    fi
  fi
}

dotfilesreqadmin() {
  if __am_i_online; then
    if cmd_exists pkmgr; then
      local confdir="$SYSUPDATEDIR"
      declare -a LISTARRAY="$*"
      for conf in ${LISTARRAY[*]}; do
        if [ ! -f "$confdir/$conf" ] && [ ! -f "$TEMP/$conf.inst.tmp" ]; then
          execute \
            "dotfilesreqadmincmd" \
            "Installing required dotfile $conf"
        fi
      done
      rm_rf $TEMP/*.inst.tmp
    fi
  fi
}

##################################################################################################

install_required() {
  if __am_i_online; then
    [[ $# -eq 0 ]] && return 0
    # local MISSING=""
    # for cmd in "$@"; do cmd_exists $cmd || MISSING+="$cmd "; done
    # if [ ! -z "$MISSING" ]; then
    #   if cmd_exists "pkmgr"; then
    #     printf_warning "Installing from package list"
    #     printf_warning "Still missing: $MISSING"
    #     if cmd_exists yay; then
    #       pkmgr --enable-aur dotfiles "$APPNAME"
    #     else
    #       pkmgr dotfiles "$APPNAME"
    #     fi
    #   fi
    # fi
  fi
  # unset MISSING
}

##################################################################################################

install_packages() {
  if __am_i_online; then
    local MISSING=""
    if cmd_exists "pkmgr"; then
      for cmd in "$@"; do cmd_exists "$cmd" || MISSING+="$cmd "; done
      if [ ! -z "$MISSING" ]; then
        printf_warning "Attempting to install missing packages"
        printf_warning "$MISSING"
        for miss in $MISSING; do
          if cmd_exists yay; then
            execute "sudo_pkmgr --enable-aur silent $miss" "Installing $miss"
          else
            execute "sudo_pkmgr silent $miss" "Installing $miss"
          fi
        done
      fi
      unset MISSING

      for cmd in "$@"; do cmd_exists "$cmd" || MISSING+="$cmd "; done
      if [ ! -z "$MISSING" ]; then
        printf_warning "Still missing:"
        printf_warning "$MISSING"
        if cmd_exists yay; then
          sudo_pkmgr --enable-aur dotfiles "$APPNAME"
        else
          sudo_pkmgr dotfiles "$APPNAME"
        fi
      fi
      unset MISSING

      for cmd in "$@"; do cmd_exists "$cmd" || MISSING+="$cmd "; done
      if [ ! -z "$MISSING" ]; then
        printf_warning "Can not install the required packages for $APPNAME"
        #if [ -f "$APPDIR/install.sh" ]; then
        #  devnull unlink -f "$APPDIR" || devnull rm -Rf "$APPDIR"
        #fi
        #set -eE
        return 1
      fi
    fi
  fi
  unset MISSING
}

##################################################################################################

install_python() {
  if __am_i_online; then
    local MISSING=""
    for cmd in "$@"; do python_missing "$cmd"; done
    if [ ! -z "$MISSING" ]; then
      if cmd_exists "pkmgr"; then
        printf_warning "Attempting to install missing python packages"
        printf_warning "$MISSING"
        for miss in $MISSING; do
          if cmd_exists yay; then
            execute "sudo_pkmgr --enable-aur silent $miss" "Installing $miss"
          else
            execute "sudo_pkmgr silent $miss" "Installing $miss"
          fi
        done
      fi
    fi
  fi
  unset MISSING
}

##################################################################################################

install_perl() {
  if __am_i_online; then
    local MISSING=""
    for cmd in "$@"; do perl_missing "$cmd"; done
    if [ ! -z "$MISSING" ]; then
      if cmd_exists "pkmgr"; then
        printf_warning "Attempting to install missing perl packages"
        printf_warning "$MISSING"
        for miss in $MISSING; do
          if cmd_exists yay; then
            execute "sudo_pkmgr --enable-aur silent $miss" "Installing $miss"
          else
            execute "sudo_pkmgr silent $miss" "Installing $miss"
          fi
        done
      fi
    fi
  fi
  unset MISSING
}

##################################################################################################

install_pip() {
  if __am_i_online; then
    local MISSING=""
    for cmd in "$@"; do cmd_exists $cmd || pip_missing "$cmd"; done
    if [ ! -z "$MISSING" ]; then
      if cmd_exists "pkmgr"; then
        printf_warning "Attempting to install missing pip packages"
        printf_warning "$MISSING"
        for miss in $MISSING; do
          execute "sudo_pkmgr pip $miss" "Installing $miss"
        done
      fi
    fi
  fi
  unset MISSING
}

##################################################################################################

install_cpan() {
  if __am_i_online; then
    local MISSING=""
    for cmd in "$@"; do cmd_exists $cmd || cpan_missing "$cmd"; done
    if [ ! -z "$MISSING" ]; then
      if cmd_exists "pkmgr"; then
        printf_warning "Attempting to install missing cpan packages"
        printf_warning "$MISSING"
        for miss in $MISSING; do
          execute "sudo_pkmgr cpan $miss" "Installing $miss"
        done
      fi
    fi
    unset MISSING
  fi
}

##################################################################################################

install_gem() {
  if __am_i_online; then
    local MISSING=""
    for cmd in "$@"; do cmd_exists $cmd || gem_missing $cmd; done
    if [ ! -z "$MISSING" ]; then
      if cmd_exists "pkmgr"; then
        printf_warning "Attempting to install missing gem packages"
        printf_warning "$MISSING"
        for miss in $MISSING; do
          execute "sudo_pkmgr gem $miss" "Installing $miss"
        done
      fi
    fi
  fi
  unset MISSING
}

##################################################################################################

trim() {
  local IFS=' '
  local trimmed="${*//[[:space:]]/}"
  echo "$trimmed"
}

##################################################################################################

kill_all_subprocesses() {
  local i=""
  for i in $(jobs -p); do
    kill "$i"
    wait "$i" &>/dev/null
  done
}

##################################################################################################

execute() {
  local -r CMDS="$1"
  local -r MSG="${2:-$1}"
  local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
  local exitCode=0
  local cmdsPID=""
  set_trap "EXIT" "kill_all_subprocesses"
  eval "$CMDS" &>/dev/null 2>"$TMP_FILE" &
  cmdsPID=$!
  show_spinner "$cmdsPID" "$CMDS" "$MSG"
  wait "$cmdsPID" &>/dev/null
  exitCode=$?
  printf_execute_result $exitCode "$MSG"
  if [ $exitCode -ne 0 ]; then
    printf_execute_error_stream <"$TMP_FILE"
  fi
  if [ "$*" = "--verbose" ] || [ "$*" = "--vdebug" ]; then
    if [ -f "$TMP_FILE" ]; then
      cat "$TMP_FILE" >>"$LOGDIR/debug/$APPNAME.debug"
    fi
  fi
  rm -rf "$TMP_FILE"
  return $exitCode
}

##################################################################################################

show_spinner() {
  local -r FRAMES='/-\|'
  local -r NUMBER_OR_FRAMES=${#FRAMES}
  local -r CMDS="$2"
  local -r MSG="$3"
  local -r PID="$1"
  local i=0
  local frameText=""
  while kill -0 "$PID" &>/dev/null; do
    frameText="                [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
    printf "%s" "$frameText"
    sleep 0.2
    printf "\r"
  done
}

##################################################################################################

git_repo_urls() {
  REPO="${REPO:-https://github.com/dfmgr}"
  REPORAW="${REPORAW:-$REPO/$APPNAME/raw}"
}

##################################################################################################

os_support() {
  if [ -n "$1" ]; then
    OSTYPE="$(echo $1 | tr '[:upper:]' '[:lower:]')"
  else
    OSTYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"
  fi
  case "$OSTYPE" in
  linux*) echo "Linux" || return 1 ;;
  mac* | darwin*) echo "MacOS" || return 1 ;;
  win* | msys* | mingw* | cygwin*) echo "Windows" || return 1 ;;
  bsd*) echo "BSD" || return 1 ;;
  solaris*) echo "Solaris" || return 1 ;;
  *) echo "Unknown OS" || return 1 ;;
  esac
}

unsupported_oses() {
  for OSes in "$@"; do
    if [[ "$(echo $1 | tr '[:upper:]' '[:lower:]')" =~ $(os_support) ]]; then
      printf_red "\t\t$(os_support $OSes) is not supported\n"
      exit
    fi
  done
}

if_os() {
  UNAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
  case "$1" in
  linux)
    if [[ "$UNAME" =~ ^linux ]]; then
      return 0
    else
      return 1
    fi
    ;;

  mac*)
    if [[ "$UNAME" =~ ^darwin ]]; then
      return 0
    else
      return 1
    fi
    ;;
  win*)
    if [[ "$UNAME" =~ ^ming ]]; then
      return 0
    else
      return 1
    fi
    ;;
  *)
    return 1
    ;;
  esac
}

if_os_id() {
  if [ -f "/etc/os-release" ]; then
    local distroname=$(grep ID_LIKE= /etc/os-release | sed 's#ID_LIKE=##')
  elif [ -f "/etc/redhat-release" ]; then
    local distroname=$(cat /etc/redhat-release)
  elif [ -f "$(command -v lsb_release)" ]; then
    local distroname="$(lsb_release -a | grep 'Distributor ID' | awk '{print $3}')"
  else
    local distroname="unknown"
  fi
  for id_like in "$@"; do
    if [[ "$(echo $1 | tr '[:upper:]' '[:lower:]')" =~ $id_like ]]; then
      case "$1" in
      Arch* | arch*)
        if [[ "$distroname" =~ "ArcoLinux" ]] || [[ "$distroname" =~ "Arch" ]] || [[ "$distroname" =~ "BlackArch" ]]; then
          distro_id=Arch
          return 0
        else
          return 1
        fi
        ;;
      RHEL* | rhel*)
        if [[ "$distroname" =~ "Scientific" ]] || [[ "$distroname" =~ "RedHat" ]] || [[ "$distroname" =~ "CentOS" ]] || [[ "$distroname" =~ "Casjay" ]] || [[ "$distroname" =~ "Fedora" ]]; then
          distro_id=RHEL
          return 0
        else
          return 1
        fi
        ;;
      Debian* | debian)
        if [[ "$distroname" =~ "Kali" ]] || [[ "$distroname" =~ "Parrot" ]] || [[ "$distroname" =~ "Debian" ]] || [[ "$distroname" =~ "Raspbian" ]] ||
          [[ "$distroname" =~ "Ubuntu" ]] || [[ "$distroname" =~ "Mint" ]] || [[ "$distroname" =~ "Elementary" ]] || [[ "$distroname" =~ "KDE neon" ]]; then
          distro_id=Debian
          return 0
        else
          return 1
        fi
        ;;
      *)
        return 1
        ;;
      esac
    else
      return 1
    fi
  done
}

##################################################################################################

user_installdirs() {
  touch "$TEMP/$APPNAME.inst.tmp"
  APPNAME="${APPNAME:-installer}"

  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    export INSTALL_TYPE=user
    if [[ "$OSTYPE" =~ ^darwin ]]; then
      export HOME="/usr/local/share/CasjaysDev/root"
      chmod -Rf 777 "/usr/local/share/CasjaysDev/root"
    else
      export HOME="${HOME:-/root}"
    fi
    export BIN="$HOME/.local/bin"
    export CONF="$HOME/.config"
    export SHARE="$HOME/.local/share"
    export LOGDIR="$HOME/.local/log"
    export STARTUP="$HOME/.config/autostart"
    export SYSBIN="/usr/local/bin"
    export SYSCONF="/usr/local/etc"
    export SYSSHARE="/usr/local/share"
    export SYSLOGDIR="/usr/local/log"
    export BACKUPDIR="$HOME/.local/backups"
    export COMPDIR="$HOME/.local/share/bash-completion/completions"
    export THEMEDIR="$SHARE/themes"
    export ICONDIR="$SHARE/icons"
    export FONTDIR="$SHARE/fonts"
    export FONTCONF="$SYSCONF/fontconfig/conf.d"
    export CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    export CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    export WALLPAPERS="${WALLPAPERS:-$SYSSHARE/wallpapers}"
    export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
    #USRUPDATEDIR="$SHARE/CasjaysDev/apps/dotfiles"
    #SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/dotfiles"
  else
    export INSTALL_TYPE=user
    export HOME="${HOME}"
    export BIN="$HOME/.local/bin"
    export CONF="$HOME/.config"
    export SHARE="$HOME/.local/share"
    export LOGDIR="$HOME/.local/log"
    export STARTUP="$HOME/.config/autostart"
    export SYSBIN="$HOME/.local/bin"
    export SYSCONF="$HOME/.config"
    export SYSSHARE="$HOME/.local/share"
    export SYSLOGDIR="$HOME/.local/log"
    export BACKUPDIR="$HOME/.local/backups"
    export COMPDIR="$HOME/.local/share/bash-completion/completions"
    export THEMEDIR="$SHARE/themes"
    export ICONDIR="$SHARE/icons"
    export FONTDIR="$SHARE/fonts"
    export FONTCONF="$SYSCONF/fontconfig/conf.d"
    export CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    export CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    export WALLPAPERS="$HOME/.local/share/wallpapers"
    export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
    #USRUPDATEDIR="$SHARE/CasjaysDev/apps/dotfiles"
    #SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/dotfiles"
  fi
  git_repo_urls
}

##################################################################################################

system_installdirs() {
  touch "$TEMP/$APPNAME.inst.tmp"
  APPNAME="${APPNAME:-installer}"

  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    #printf_info "Install Type: system - ${WHOAMI}"
    #printf_red "\t\tInstalling as root ?\n"
    export INSTALL_TYPE=system
    export HOME="/usr/local/share/CasjaysDev/root"
    export BACKUPDIR="$HOME/.local/backups"
    export BIN="/usr/local/bin"
    export CONF="/usr/local/etc"
    export SHARE="/usr/local/share"
    export LOGDIR="/usr/local/log"
    export STARTUP="/dev/null"
    export SYSBIN="/usr/local/bin"
    export SYSCONF="/usr/local/etc"
    export SYSSHARE="/usr/local/share"
    export SYSLOGDIR="/usr/local/log"
    export COMPDIR="/etc/bash_completion.d"
    export THEMEDIR="/usr/local/share/themes"
    export ICONDIR="/usr/local/share/icons"
    export FONTDIR="/usr/local/share/fonts"
    export FONTCONF="/usr/local/share/fontconfig/conf.d"
    export CASJAYSDEVSHARE="/usr/local/share/CasjaysDev"
    export CASJAYSDEVSAPPDIR="/usr/local/share/CasjaysDev/apps"
    export WALLPAPERS="/usr/local/share/wallpapers"
    export DOWNLOADED_TO="/usr/local/share/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
    #USRUPDATEDIR="/usr/local/share/CasjaysDev/apps"
    #SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps"
    chmod -Rf 777 "/usr/local/share/CasjaysDev/root"
    mkd /etc/casjaysdev/updates/versions
  else
    export INSTALL_TYPE=system
    export HOME="${HOME:-/home/$WHOAMI}"
    export BACKUPDIR="${BACKUPS:-$HOME/.local/backups}"
    export BIN="$HOME/.local/bin"
    export CONF="$HOME/.config"
    export SHARE="$HOME/.local/share"
    export LOGDIR="$HOME/.local/log"
    export STARTUP="$HOME/.config/autostart"
    export SYSBIN="$HOME/.local/bin"
    export SYSCONF="$HOME/.local/etc"
    export SYSSHARE="$HOME/.local/share"
    export SYSLOGDIR="$HOME/.local/log"
    export COMPDIR="$HOME/.local/share/bash-completion/completions"
    export THEMEDIR="$HOME/.local/share/themes"
    export ICONDIR="$HOME/.local/share/icons"
    export FONTDIR="$HOME/.local/share/fonts"
    export FONTCONF="$HOME/.local/share/fontconfig/conf.d"
    export CASJAYSDEVSHARE="$HOME/.local/share/CasjaysDev"
    export CASJAYSDEVSAPPDIR="$HOME/.local/share/CasjaysDev/apps"
    export WALLPAPERS="$HOME/.local/share/wallpapers"
    export DOWNLOADED_TO="$HOME/.local/share/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
    #USRUPDATEDIR="$HOME/.local/share/CasjaysDev/apps"
    #SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps"
  fi
  git_repo_urls
}

##################################################################################################

ensure_dirs() {
  if [[ $EUID -ne 0 ]] || [[ "$WHOAMI" != "root" ]]; then
    mkd "$BIN"
    mkd "$SHARE"
    mkd "$LOGDIR"
    mkd "$LOGDIR/dfmgr"
    mkd "$LOGDIR/fontmg"
    mkd "$LOGDIR/iconmgr"
    mkd "$LOGDIR/systemmgr"
    mkd "$LOGDIR/thememgr"
    mkd "$LOGDIR/wallpapermgr"
    mkd "$COMPDIR"
    mkd "$STARTUP"
    mkd "$BACKUPDIR"
    mkd "$FONTDIR"
    mkd "$ICONDIR"
    mkd "$THEMEDIR"
    mkd "$FONTCONF"
    mkd "$CASJAYSDEVSHARE"
    mkd "$CASJAYSDEVSAPPDIR"
    mkd "$USRUPDATEDIR"
    mkd "$SYSUPDATEDIR"
    mkd "$SHARE/applications"
    mkd "$SHARE/CasjaysDev/functions"
    mkd "$SHARE/wallpapers/system"
    [ -d "$APPDIR" ] || mkd "$APPDIR"
  fi
  return 0
}

##################################################################################################

ensure_perms() {
  # chown -Rf "$WHOAMI":"$WHOAMI" "$LOGDIR"
  # chown -Rf "$WHOAMI":"$WHOAMI" "$BACKUPDIR"
  # chown -Rf "$WHOAMI":"$WHOAMI" "$CASJAYSDEVSHARE"
  # chown -Rf "$WHOAMI":"$WHOAMI" "$HOME/.local/backups"
  # chown -Rf "$WHOAMI":"$WHOAMI" "$HOME/.local/log"
  # chown -Rf "$WHOAMI":"$WHOAMI" "$HOME/.local/share/CasjaysDev"
  # chmod -Rf 755 "$SHARE"
  # chmod -Rf 755 "$LOGDIR"
  # chmod -Rf 755 "$BACKUPDIR"
  # chmod -Rf 755 "$CASJAYSDEVSHARE"
  # chmod -Rf 755 "$HOME/.local/backups"
  # chmod -Rf 755 "$HOME/.local/log"
  # chmod -Rf 755 "$HOME/.local/share/CasjaysDev"
  return 0
}

##################################################################################################

get_app_version() {
  if [ -f "$APPDIR/version.txt" ]; then
    local version="$(cat "$APPDIR/version.txt" | grep -v "#" | tail -n 1)"
  else
    local version="0000000"
  fi
  local GITREPO=""$REPO/$APPNAME""
  local APPVERSION="${APPVERSION:-$(__appversion)}"
  [ -n "$WHOAMI" ] && printf_info "WhoamI:                    $WHOAMI"
  [ -n "$INSTALL_TYPE" ] && printf_info "Install Type:              $INSTALL_TYPE"
  [ -n "$APPNAME" ] && printf_info "APP name:                  $APPNAME"
  [ -n "$APPDIR" ] && printf_info "APP dir:                   $APPDIR"
  [ -n "$DOWNLOADED_TO" ] && printf_info "Downloaded to:             $DOWNLOADED_TO"
  [ -n "$GITREPO" ] && printf_info "APP repo:                  $REPO/$APPNAME"
  [ -n "$PLUGNAMES" ] && printf_info "Plugins:                   $PLUGNAMES"
  [ -n "$PLUGDIR" ] && printf_info "PluginsDir:                $PLUGDIR"
  [ -n "$version" ] && printf_info "Installed Version:         $version"
  [ -n "$APPVERSION" ] && printf_info "Online Version:            $APPVERSION"
  if [ "$version" = "$APPVERSION" ]; then
    printf_info "Update Available:          No"
  else
    printf_info "Update Available:          Yes"
  fi
}

##################################################################################################

app_uninstall() {
  if [ -d "$APPDIR" ]; then
    printf_yellow "\n\t\tRemoving $APPNAME from your system\n"
    [ -d "$DOWNLOADED_TO" ] && rm_rm "$DOWNLOADED_TO"
    rm_rf "$APPDIR" &&
      rm_rf "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME" &&
      rm_rf "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" &&
      broken_symlinks $BIN $SHARE $COMPDIR $CONF
    getexitcode "\n\t\t$APPNAME has been removed\n"
  else
    printf_red "\n\t\t$APPNAME doesn't seem to be installed\n"
    return 1
  fi
}

##################################################################################################

show_optvars() {
  if [ "$1" = "--update" ]; then
    versioncheck
    exit "$?"
  fi

  if [ "$1" = "--cron" ]; then
    shift 1
    [ "$1" = "--help" ] && printf_help "Usage: $APPNAME --cron remove | add" && exit 0
    [ "$1" = "--cron" ] && shift 1
    [ "$1" = "cron" ] && shift 1
    crontab_add "$*"
    exit "$?"
  fi

  if [ "$1" = "--stow" ]; then
    [ "$1" = "--help" ] && config --help
    shift 1
    config add "$*"
    exit "$?"
  fi

  if [ "$1" = "--help" ]; then
    #    if cmd_exists xdg-open; then
    #      xdg-open "$REPO/$APPNAME"
    #    elif cmd_exists open; then
    #      open "$REPO/$APPNAME"
    #    else
    printf_cyan "\t\tGo to $REPO/$APPNAME for help"
    #    fi
    exit
  fi

  if [ "$1" = "--version" ]; then
    get_app_version
    exit $?
  fi

  if [ "$1" = "--remove" ] || [ "$1" = "--uninstall" ]; then
    shift 1
    app_uninstall
    exit $?
  fi

  path_info() {
    echo "$PATH" | tr ':' '\n' | sort -u
  }

  if [ "$1" = "--location" ]; then
    printf_info "AppName:                   $APPNAME"
    printf_info "Installed to:              $APPDIR"
    printf_info "Downloaded to:             $DOWNLOADED_TO"
    printf_info "UserHomeDir:               $HOME"
    printf_info "UserBinDir:                $BIN"
    printf_info "UserConfDir:               $CONF"
    printf_info "UserShareDir:              $SHARE"
    printf_info "UserLogDir:                $LOGDIR"
    printf_info "UserStartDir:              $STARTUP"
    printf_info "SysConfDir:                $SYSCONF"
    printf_info "SysBinDir:                 $SYSBIN"
    printf_info "SysConfDir:                $SYSCONF"
    printf_info "SysShareDir:               $SYSSHARE"
    printf_info "SysLogDir:                 $SYSLOGDIR"
    printf_info "SysBackUpDir:              $BACKUPDIR"
    printf_info "CompletionsDir:            $COMPDIR"
    printf_info "CasjaysDevDir:             $CASJAYSDEVSHARE"
    exit $?
  fi

  if [ "$1" = "--full" ]; then
    get_app_version
    printf_info "UserHomeDir:               $HOME"
    printf_info "UserBinDir:                $BIN"
    printf_info "UserConfDir:               $CONF"
    printf_info "UserShareDir:              $SHARE"
    printf_info "UserLogDir:                $LOGDIR"
    printf_info "UserStartDir:              $STARTUP"
    printf_info "SysConfDir:                $SYSCONF"
    printf_info "SysBinDir:                 $SYSBIN"
    printf_info "SysConfDir:                $SYSCONF"
    printf_info "SysShareDir:               $SYSSHARE"
    printf_info "SysLogDir:                 $SYSLOGDIR"
    printf_info "SysBackUpDir:              $BACKUPDIR"
    printf_info "ApplicationsDir:           $SHARE/applications"
    printf_info "ThemeDir                   $THEMEDIR"
    printf_info "FontDir:                   $SHARE/fonts"
    printf_info "FontConfDir:               $FONTCONF"
    printf_info "CompletionsDir:            $COMPDIR"
    printf_info "CasjaysDevDir:             $CASJAYSDEVSHARE"
    printf_info "DevEnv Repo:               $DEVENVMGRREPO"
    printf_info "Package Manager Repo:      $PKMGRREPO"
    printf_info "Icon Manager Repo:         $ICONMGRREPO"
    printf_info "Font Manager Repo:         $FONTMGRREPO"
    printf_info "Theme Manager Repo         $THEMEMGRREPO"
    printf_info "System Manager Repo:       $SYSTEMMGRREPO"
    printf_info "Wallpaper Manager Repo:    $WALLPAPERMGRREPO"
    printf_info "REPORAW:                   $REPO/$APPNAME/raw"
    exit $?
  fi

  if [ "$1" = "--debug" ]; then
    get_app_version
    printf_info "UserHomeDir:               $HOME"
    printf_info "UserBinDir:                $BIN"
    printf_info "UserConfDir:               $CONF"
    printf_info "UserShareDir:              $SHARE"
    printf_info "UserLogDir:                $LOGDIR"
    printf_info "UserStartDir:              $STARTUP"
    printf_info "SysConfDir:                $SYSCONF"
    printf_info "SysBinDir:                 $SYSBIN"
    printf_info "SysConfDir:                $SYSCONF"
    printf_info "SysShareDir:               $SYSSHARE"
    printf_info "SysLogDir:                 $SYSLOGDIR"
    printf_info "SysBackUpDir:              $BACKUPDIR"
    printf_info "ApplicationsDir:           $SHARE/applications"
    printf_info "IconDir:                   $ICONDIR"
    printf_info "ThemeDir                   $THEMEDIR"
    printf_info "FontDir:                   $FONTDIR"
    printf_info "FontConfDir:               $FONTCONF"
    printf_info "CompletionsDir:            $COMPDIR"
    printf_info "CasjaysDevDir:             $CASJAYSDEVSHARE"
    printf_info "CASJAYSDEVSAPPDIR:         $CASJAYSDEVSAPPDIR"
    printf_info "USRUPDATEDIR:              $USRUPDATEDIR"
    printf_info "SYSUPDATEDIR:              $SYSUPDATEDIR"
    printf_info "DOTFILESREPO:              $DOTFILESREPO"
    printf_info "DevEnv Repo:               $DEVENVMGRREPO"
    printf_info "Package Manager Repo:      $PKMGRREPO"
    printf_info "Icon Manager Repo:         $ICONMGRREPO"
    printf_info "Font Manager Repo:         $FONTMGRREPO"
    printf_info "Theme Manager Repo         $THEMEMGRREPO"
    printf_info "System Manager Repo:       $SYSTEMMGRREPO"
    printf_info "Wallpaper Manager Repo:    $WALLPAPERMGRREPO"
    printf_info "Downloaded to:             $DOWNLOADED_TO"
    printf_info "REPORAW:                   $REPO/$APPNAME/raw"
    printf_info "Prefix:                    $SCRIPTS_PREFIX"
    for PATHS in $(path_info); do
      printf_info "PATHS:                     $PATHS"
    done
    exit $?
  fi

  if [ "$1" = "--installed" ]; then
    printf_green "\t\tUser                               Group                              AppName"
    ls -l $CASJAYSDEVSAPPDIR/dotfiles | tr -s ' ' | cut -d' ' -f3,4,9 | sed 's# #                               #g' | grep -v "total." | printf_readline "5"
    exit $?
  fi

}

##################################################################################################

installer_noupdate() {
  if [ "$1" != "--force" ]; then
    if [ -f "$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX/$APPNAME" ] || [ -d $APPDIR ]; then
      ln_sf "$APPDIR/install.sh" "$SYSUPDATEDIR/$APPNAME"
      printf_warning "Updating of $APPNAME has been disabled"
      exit 0
    fi
  fi
}

##################################################################################################

install_version() {
  mkdir -p "$CASJAYSDEVSAPPDIR/dotfiles" "$CASJAYSDEVSAPPDIR/dotfiles"
  if [ -f "$APPDIR/install.sh" ] && [ -f "$APPDIR/version.txt" ]; then
    if [ "$APPNAME" = "installer" ] && [ -d "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX" ]; then
      ln_sf "$APPDIR/version.txt" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/scripts"
      ln_sf "$APPDIR/version.txt" "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-scripts"
    fi
    ln_sf "$APPDIR/version.txt" "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME"
  fi
  if [ -f "$DOWNLOADED_TO/install.sh" ] && [ -f "$DOWNLOADED_TO/version.txt" ]; then
    ln_sf "$DOWNLOADED_TO/version.txt" "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME"
  fi
  if [ -d "$DOWNLOADED_TO" ] && [ -f "$DOWNLOADED_TO/install.sh" ] && [ -f "$DOWNLOADED_TO/version.txt" ]; then
    ln_sf "$DOWNLOADED_TO/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  fi

}

##################################################################################################

dfmgr_install() {
  user_installdirs
  export SCRIPTS_PREFIX="dfmgr"
  export REPO="${DFMGRREPO}"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$CONF"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/dfmgr"
  export SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/dfmgr"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
}

dfmgr_run_post() {
  dfmgr_install
  run_postinst_global
  [ -d "$APPDIR" ] && replace "$APPDIR" "replacehome" "$HOME"
  [ -d "$APPDIR" ] && replace "$APPDIR" "/home/jason" "$HOME"
}

dfmgr_install_version() {
  dfmgr_install
  install_version
  mkdir -p "$CASJAYSDEVSAPPDIR/dfmgr" "$CASJAYSDEVSAPPDIR/dfmgr"
  if [ -f "$APPDIR/install.sh" ] && [ -f "$APPDIR/version.txt" ]; then
    ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/dfmgr/$APPNAME"
  fi
}

##################################################################################################

dockermgr_install() {
  user_installdirs
  export SCRIPTS_PREFIX="dockermgr"
  export REPO="${DFMGRREPO}"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$CONF"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/dockermgr"
  export SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/dockermgr"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
}

dockermgr_run_post() {
  dockermgr_install
  run_postinst_global
  [ -d "$APPDIR" ] && replace "$APPDIR" "/home/jason" "$HOME"
}

dockermgr_install_version() {
  dockermgr_install
  install_version
  mkdir -p "$CASJAYSDEVSAPPDIR/dockermgr" "$CASJAYSDEVSAPPDIR/dockermgr"
  if [ -f "$APPDIR/install.sh" ] && [ -f "$APPDIR/version.txt" ]; then
    ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/dockermgr/$APPNAME"
  fi
}

##################################################################################################

fontmgr_install() {
  system_installdirs
  export SCRIPTS_PREFIX="fontmgr"
  export REPO="${FONTMGRREPO}"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SHARE/CasjaysDev/fontmgr"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/fontmgr"
  export SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/fontmgr"
  export FONTDIR="${FONTDIR:-$SHARE/fonts}"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
}

fontmgr_run_post() {
  fontmgr_install
  run_postinst_global
  if [ -d "$HOME/Library/Fonts" ] && [ -d "$APPDIR/fonts" ]; then
    ln_sf "$APPDIR/fonts" "$HOME/Library/Fonts"
  fi
  fc-cache -f "$ICONDIR"
}

fontmgr_install_version() {
  fontmgr_install
  install_version
  mkdir -p "$CASJAYSDEVSAPPDIR/fontmgr" "$CASJAYSDEVSAPPDIR/fontmgr"
  if [ -f "$APPDIR/install.sh" ] && [ -f "$APPDIR/version.txt" ]; then
    ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/fontmgr/$APPNAME"
  fi
}

##################################################################################################

iconmgr_install() {
  system_installdirs
  export SCRIPTS_PREFIX="iconmgr"
  export REPO="${ICONMGRREPO}"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SYSSHARE/CasjaysDev/iconmgr"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/iconmgr"
  export SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/iconmgr"
  export ICONDIR="${ICONDIR:-$SHARE/icons}"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
}

iconmgr_run_post() {
  iconmgr_install
  run_postinst_global
  [ -d "$ICONDIR/$APPNAME" ] || ln_sf "$APPDIR" "$ICONDIR/$APPNAME"
  devnull sudo find "$ICONDIR/$APPNAME" -type d -exec chmod 755 {} \;
  devnull sudo find "$ICONDIR/$APPNAME" -type f -exec chmod 644 {} \;
  devnull sudo gtk-update-icon-cache -q -t -f "$ICONDIR/$APPNAME"
}

iconmgr_install_version() {
  iconmgr_install
  install_version
  mkdir -p "$CASJAYSDEVSAPPDIR/iconmgr" "$CASJAYSDEVSAPPDIR/apps/iconmgr"
  if [ -f "$APPDIR/install.sh" ] && [ -f "$APPDIR/version.txt" ]; then
    ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/iconmgr/$APPNAME"
  fi
}

generate_icon_index() {
  iconmgr_install
  ICONDIR="${ICONDIR:-$SHARE/icons}"
  fc-cache -f "$ICONDIR"
}

##################################################################################################

pkmgr_install() {
  system_installdirs
  export SCRIPTS_PREFIX="pkmgr"
  export REPO="${PKMGRREPO}"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SYSSHARE/CasjaysDev/pkmgr"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/pkmgr"
  export SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/pkmgr"
  export REPODF="https://raw.githubusercontent.com/pkmgr/dotfiles/master"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
}

pkmgr_run_postinst() {
  pkmgr_install
  run_postinst_global
}

pkmgr_install_version() {
  pkmgr_install
  install_version
  mkdir -p "$CASJAYSDEVSAPPDIR/pkmgr" "$CASJAYSDEVSAPPDIR/pkmgr"
  if [ -f "$APPDIR/install.sh" ] && [ -f "$APPDIR/version.txt" ]; then
    ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/pkmgr/$APPNAME"
  fi
}

##################################################################################################

systemmgr_install() {
  requiresudo "true"
  system_installdirs
  export SCRIPTS_PREFIX="systemmgr"
  export REPO="${SYSTEMMGRREPO}"
  export REPORAW="$REPO/$APPNAME/raw"
  export CONF="/usr/local/etc"
  export SHARE="/usr/local/share"
  export HOMEDIR="/usr/local/etc"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/systemmgr"
  export SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/systemmgr"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
}

systemmgr_run_postinst() {
  systemmgr_install
  run_postinst_global
}

systemmgr_install_version() {
  systemmgr_install
  install_version
  mkdir -p "$SYSUPDATEDIR"
  if [ -f "$APPDIR/install.sh" ] && [ -f "$APPDIR/version.txt" ]; then
    ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/systemmgr/$APPNAME"
  fi
}

##################################################################################################

thememgr_install() {
  system_installdirs
  export SCRIPTS_PREFIX="thememgr"
  export REPO="${THEMEMGRREPO}"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SYSSHARE/CasjaysDev/thememgr"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/thememgr"
  export SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/thememgr"
  export THEMEDIR="${THEMEDIR:-$SHARE/themes}"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
}

generate_theme_index() {
  thememgr_install
  THEMEDIR="${THEMEDIR:-$SHARE/themes}"
  sudo find "$THEMEDIR" -mindepth 1 -maxdepth 2 -type d -not -path "*/.git/*" | while read -r THEME; do
    if [ -f "$THEME/index.theme" ]; then
      cmd_exists gtk-update-icon-cache && gtk-update-icon-cache -f -q "$THEME"
    fi
  done
}

thememgr_run_post() {
  thememgr_install
  run_postinst_global
  [ -d "$THEMEDIR/$APPNAME" ] || ln_sf "$APPDIR" "$THEMEDIR/$APPNAME"
  generate_theme_index
}

thememgr_install_version() {
  thememgr_install
  install_version
  mkdir -p "$CASJAYSDEVSAPPDIR/thememgr" "$CASJAYSDEVSAPPDIR/thememgr"
  if [ -f "$APPDIR/install.sh" ] && [ -f "$APPDIR/version.txt" ]; then
    ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/thememgr/$APPNAME"
  fi
}

##################################################################################################

wallpapermgr_install() {
  system_installdirs
  export SCRIPTS_PREFIX="wallpapermgr"
  export REPO="${WALLPAPERMGRREPO}"
  export REPORAW="$REPO/$APPNAME/raw"
  export HOMEDIR="$SYSSHARE/CasjaysDev/wallpapers"
  export APPDIR="${APPDIR:-$HOMEDIR/$APPNAME}"
  export USRUPDATEDIR="$SHARE/CasjaysDev/apps/wallpapers"
  export SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/wallpapers"
  export WALLPAPERS="${WALLPAPERS:-$SHARE/wallpapers}"
  export DOWNLOADED_TO="$SHARE/CasjaysDev/installed/$SCRIPTS_PREFIX/$APPNAME"
  export APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
}

wallpapermgr_run_postinst() {
  wallpapermgr_install
  run_postinst_global
}

wallpaper_install_version() {
  wallpapermgr_install
  mkdir -p "$CASJAYSDEVSAPPDIR/wallpapermgr" "$CASJAYSDEVSAPPDIR/wallpapermgr"
  if [ -f "$APPDIR/install.sh" ] && [ -f "$APPDIR/version.txt" ]; then
    ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/wallpapermgr/$APPNAME"
  fi
}

##################################################################################################

run_postinst_global() {
  if [ ! -d "$DOWNLOADED_TO" ] || [ ! -L "$DOWNLOADED_TO" ]; then ln_sf "$APPDIR" "$DOWNLOADED_TO"; fi
  if [[ "$APPNAME" = "scripts" ]] || [[ "$APPNAME" = "installer" ]]; then
    # Only run on the scripts install
    ln_rm "$SYSBIN/"
    ln_rm "$COMPDIR/"

    dfunFiles="$(ls $DOWNLOADED_TO/completions)"
    for dfun in $dfunFiles; do
      rm_rf "$COMPDIR/$dfun"
    done

    myfunctFiles="$(ls $DOWNLOADED_TO/functions)"
    for myfunct in $myfunctFiles; do
      ln_sf "$DOWNLOADED_TO/functions/$myfunct" "$HOME/.local/share/CasjaysDev/functions/$myfunct"
    done

    compFiles="$(ls $DOWNLOADED_TO/completions)"
    for comp in $compFiles; do
      cp_rf "$DOWNLOADED_TO/completions/$comp" "$COMPDIR/$comp"
    done

    appFiles="$(ls $DOWNLOADED_TO/bin)"
    for app in $appFiles; do
      chmod -Rf 755 "$DOWNLOADED_TO/bin/$app"
      ln_sf "$DOWNLOADED_TO/bin/$app" "$SYSBIN/$app"
    done
    cmd_exists updatedb && updatedb || return 0
  else
    # Run on everything else
    if [ "$APPDIR" != "$DOWNLOADED_TO" ]; then
      mkd "$APPDIR"
      cp_rf "$DOWNLOADED_TO/etc/." "$APPDIR/"
    fi

    if [ -d "$DOWNLOADED_TO/backgrounds" ]; then
      mkdir -p "$WALLPAPERS/system"
      local wallpapers="$(ls $DOWNLOADED_TO/backgrounds/ 2>/dev/null | wc -l)"
      if [ "$wallpapers" != "0" ]; then
        wallpaperFiles="$(ls $DOWNLOADED_TO/backgrounds)"
        for wallpaper in $wallpaperFiles; do
          ln_sf "$DOWNLOADED_TO/backgrounds/$wallpaper" "$WALLPAPERS/system/$wallpaper"
        done
      fi
    fi

    if [ -d "$DOWNLOADED_TO/startup" ]; then
      local autostart="$(ls $DOWNLOADED_TO/startup/ 2>/dev/null | wc -l)"
      if [ "$autostart" != "0" ]; then
        startFiles="$(ls $DOWNLOADED_TO/startup)"
        for start in $startFiles; do
          ln_sf "$DOWNLOADED_TO/startup/$start" "$STARTUP/$start"
        done
      fi
      ln_rm "$STARTUP/"
    fi

    if [ -d "$DOWNLOADED_TO/bin" ]; then
      local bin="$(ls $DOWNLOADED_TO/bin/ 2>/dev/null | wc -l)"
      if [ "$bin" != "0" ]; then
        bFiles="$(ls $DOWNLOADED_TO/bin)"
        for b in $bFiles; do
          chmod -Rf 755 "$DOWNLOADED_TO/bin/$app"
          ln_sf "$DOWNLOADED_TO/bin/$b" "$BIN/$b"
        done
      fi
      ln_rm "$BIN/"
    fi

    if [ -d "$DOWNLOADED_TO/completions" ]; then
      local comps="$(ls $DOWNLOADED_TO/completions/ 2>/dev/null | wc -l)"
      if [ "$comps" != "0" ]; then
        compFiles="$(ls $DOWNLOADED_TO/completions)"
        for comp in $compFiles; do
          cp_rf "$DOWNLOADED_TO/completions/$comp" "$COMPDIR/$comp"
        done
      fi
      ln_rm "$COMPDIR/"
    fi

    if [ -d "$DOWNLOADED_TO/applications" ]; then
      local apps="$(ls $DOWNLOADED_TO/applications/ 2>/dev/null | wc -l)"
      if [ "$apps" != "0" ]; then
        aFiles="$(ls $DOWNLOADED_TO/applications)"
        for a in $aFiles; do
          ln_sf "$DOWNLOADED_TO/applications/$a" "$SHARE/applications/$a"
        done
      fi
      ln_rm "$SHARE/applications/"
    fi

    if [ -d "$DOWNLOADED_TO/fontconfig" ]; then
      local fontconf="$(ls $DOWNLOADED_TO/fontconfig 2>/dev/null | wc -l)"
      if [ "$fontconf" != "0" ]; then
        fcFiles="$(ls $DOWNLOADED_TO/fontconfig)"
        for fc in $fcFiles; do
          ln_sf "$DOWNLOADED_TO/fontconfig/$fc" "$FONTCONF/$fc"
        done
      fi
      ln_rm "$FONTCONF/"
      cmd_exists fc-cache && fc-cache -f "$FONTCONF"
      return 0
    fi

    if [ -d "$DOWNLOADED_TO/fonts" ]; then
      local font="$(ls "$DOWNLOADED_TO/fonts" 2>/dev/null | wc -l)"
      if [ "$font" != "0" ]; then
        fFiles="$(ls $DOWNLOADED_TO/fonts --ignore='.conf' --ignore='.uuid')"
        for f in $fFiles; do
          ln_sf "$DOWNLOADED_TO/fonts/$f" "$FONTDIR/$f"
        done
      fi
      ln_rm "$FONTDIR/"
      cmd_exists fc-cache && fc-cache -f "$FONTDIR"
      return 0
    fi
  fi

  # Permission fix
  ensure_perms

  #  IFS="$OIFS"
}

##################################################################################################

run_exit() {
  if [ ! -f "$APPDIR/.installed" ]; then
    date '+Installed on: %m/%d/%y @ %H:%M:%S' >"$APPDIR/.installed"
  fi
  if [ -n "$DOWNLOADED_TO" ] && [ ! -f "$DOWNLOADED_TO/.installed" ]; then
    date '+Installed on: %m/%d/%y @ %H:%M:%S' >"$DOWNLOADED_TO/.installed"
  fi

  if [ -f "$TEMP/$APPNAME.inst.tmp" ]; then rm_rf "$TEMP/$APPNAME.inst.tmp"; fi
  if [ -f "/tmp/$SCRIPTSFUNCTFILE" ]; then rm_rf "/tmp/$SCRIPTSFUNCTFILE"; fi
  if [ -n "$EXIT" ]; then exit "$EXIT"; fi
}

##################################################################################################
vdebug() {
  for path in USER:$USER HOME:$HOME PREFIX:$SCRIPTS_PREFIX REPO:$REPO REPORAW:$REPORAW CONF:$CONF SHARE:$SHARE \
    HOMEDIR:$HOMEDIR APPDIR:$APPDIR USRUPDATEDIR:$USRUPDATEDIR SYSUPDATEDIR:$SYSUPDATEDIR; do
    printf_custom "4" $path
  done
}

##################################################################################################
# if [ "$*" = "--vdebug" ]; then
#   shift 1
#   vdebug
#   #set -xveE
#   mkdir -p "$LOGDIR/debug"
#   touch "$LOGDIR/debug/$APPNAME.log" "$LOGDIR/debug/$APPNAME.err"
#   chmod -Rf 755 "$LOGDIR/debug"
#   exec >>"$LOGDIR/debug/$APPNAME.debug" 2>&1
#   devnull() {
#     "$@" >>"$LOGDIR/debug/$APPNAME.log" 2>>"$LOGDIR/debug/$APPNAME.err"
#   }
#   devnull2() {
#     "$@" 2>>"$LOGDIR/debug/$APPNAME.err" >/dev/null
#   }
# fi

#set_trap "EXIT" "install_packages"
#set_trap "EXIT" "install_required"
#set_trap "EXIT" "install_python"
#set_trap "EXIT" "install_perl"
#set_trap "EXIT" "install_pip"
#set_trap "EXIT" "install_cpan"
#set_trap "EXIT" "install_gem"

# end
