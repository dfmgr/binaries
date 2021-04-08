#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="${APPNAME:-app-installer}"
FUNCFILE="app-installer.bash"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 020920211625-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : LICENSE.md
# @ReadME        : README.md
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Tuesday, Feb 09, 2021 17:17 EST
# @File          : app-installer.bash
# @Description   : Installer functions for apps
# @TODO          : Refactor code - It is a mess
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
CASJAYSDEVDIR="/usr/local/share/CasjaysDev/scripts"
# Versioning Info - __required_version "VersionNumber"
localVersion="${localVersion:-202103310525-git}"
requiredVersion="${requiredVersion:-202103310525-git}"
currentVersion="${currentVersion:-$(<$CASJAYSDEVDIR/version.txt)}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
TMPPATH="$HOME/.local/share/bash/basher/cellar/bin:$HOME/.local/share/bash/basher/bin:"
TMPPATH+="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/share/gem/bin:/usr/local/bin:"
TMPPATH+="/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$PATH:."
export PATH="$(echo "$TMPPATH" | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:.#g')"
unset TMPPATH
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export SUDO_PROMPT="$(printf "\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m")"
export TMP="${TMP:-/tmp}"
export TEMP="${TEMP:-/tmp}"
export TMPDIR="${TMPDIR:-/tmp}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export WHOAMI="${SUDO_USER:-$USER}"
export HOME="${USER_HOME:-$HOME}"
export LOGDIR="${LOGDIR:-$HOME/.local/log}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
command() {
  [ "$1" = "-v" ] && shift 1
  type -P "$1"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
  local LISTARRAY="$*"
  for pkg in $LISTARRAY; do
    type -P "$1" | grep -q "/" 2>/dev/null
  done
}
devnull() { "$@" >/dev/null 2>&1; }
devnull2() { "$@" >/dev/null 2>&1; }
# fail if git is not installed
if [ ! -f "$(type -P git 2>/dev/null)" ]; then
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
    if [ ! -f "$(type -P git 2>/dev/null)" ]; then
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
export DFMGRREPO="${DFMGRREPO:-https://github.com/dfmgr}"
export PKMGRREPO="${PKMGRREPO:-https://github.com/pkmgr}"
export DEVENVMGRREPO="${DEVENVMGR:-https://github.com/devenvmgr}"
export DOCKERMGRREPO="${DOCKERMGRREPO:-https://github.com/dockermgr}"
export ICONMGRREPO="${ICONMGRREPO:-https://github.com/iconmgr}"
export FONTMGRREPO="${FONTMGRREPO:-https://github.com/fontmgr}"
export THEMEMGRREPO="${THEMEMGRREPO:-https://github.com/thememgr}"
export SYSTEMMGRREPO="${SYSTEMMGRREPO:-https://github.com/systemmgr}"
export WALLPAPERMGRREPO="${WALLPAPERMGRREPO:-https://github.com/wallpapermgr}"
##################################################################################################
# Colors
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
printf_newline() { printf "${*:-}\n"; }
printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
printf_normal() { printf_color "\t\t$1\n" "$2"; }
printf_green() { printf_color "\t\t$1\n" 2; }
printf_red() { printf_color "\t\t$1\n" 1; }
printf_purple() { printf_color "\t\t$1\n" 5; }
printf_yellow() { printf_color "\t\t$1\n" 3; }
printf_blue() { printf_color "\t\t$1\n" 4; }
printf_cyan() { printf_color "\t\t$1\n" 6; }
printf_info() { printf_color "\t\t$ICON_INFO $1\n" 3; }
printf_success() { printf_color "\t\t$ICON_GOOD $1\n" 2; }
printf_warning() { printf_color "\t\t$ICON_WARN $1\n" 3; }
printf_error_stream() { while read -r line; do printf_error "↳ ERROR: $line"; done; }
printf_execute_success() { printf_color "\t\t$ICON_GOOD $1\n" 2; }
printf_execute_error() { printf_color "\t\t$ICON_WARN $1 $2\n" 1; }
printf_execute_error_stream() { while read -r line; do printf_execute_error "↳ ERROR: $line"; done; }
printf_execute_result() {
  if [ "$1" -eq 0 ]; then printf_execute_success "$2"; else printf_execute_error "${3:-$2}"; fi
  return "$1"
}
##################################################################################################
printf_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local msg="$*"
  shift
  printf_color "\t\t$ICON_QUESTION $msg? " "$color"
}
##################################################################################################
#printf_error "color" "exitcode" "message"
printf_error() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  printf_color "\t\t$ICON_ERROR $msg\n" "$color"
  return $exitCode
}
##################################################################################################
#printf_exit "color" "exitcode" "message"
printf_exit() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  test -n "$1" && test -z "${1//[0-9]/}" && local exitCode="$1" && shift 1 || local exitCode="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  echo ""
  exit "$exitCode"
}
##################################################################################################
# #printf_newline
printf_readline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "\t\t$line\n" "$color"
  done
  set +o pipefail
}
##################################################################################################
printf_custom() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  echo ""
}
##################################################################################################
printf_custom_question() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$*"
  shift
  printf_color "\t\t$msg " "$color"
}
##################################################################################################
printf_question_timeout() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="1"
  local msg="$1" && shift 1
  test -n "$1" && test -z "${1//[0-9]/}" && local lines="$1" && shift 1 || local lines="120"
  reply="${1:-REPLY}" && shift 1
  readopts="${1:-}" && shift 1
  printf_color "\t\t$msg " "${PRINTF_COLOR:-$color}"
  read -t 30 -r -n $lines ${readopts} ${reply}
  printf_newline
}
##################################################################################################
printf_head() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  local msg1="$1" && shift 1
  local msg2="$1" && shift 1 || msg2=
  local msg3="$1" && shift 1 || msg3=
  local msg4="$1" && shift 1 || msg4=
  local msg5="$1" && shift 1 || msg5=
  local msg6="$1" && shift 1 || msg6=
  local msg7="$1" && shift 1 || msg7=
  shift
  [ -z "$msg1" ] || printf_color "\t\t##################################################\n" "$color"
  [ -z "$msg1" ] || printf_color "\t\t$msg1\n" "$color"
  [ -z "$msg2" ] || printf_color "\t\t$msg2\n" "$color"
  [ -z "$msg3" ] || printf_color "\t\t$msg3\n" "$color"
  [ -z "$msg4" ] || printf_color "\t\t$msg4\n" "$color"
  [ -z "$msg5" ] || printf_color "\t\t$msg5\n" "$color"
  [ -z "$msg6" ] || printf_color "\t\t$msg6\n" "$color"
  [ -z "$msg7" ] || printf_color "\t\t$msg7\n" "$color"
  [ -z "$msg1" ] || printf_color "\t\t##################################################\n" "$color"
}
##################################################################################################
printf_result() {
  PREV="$4"
  [ ! -z "$1" ] && EXIT="$1" || EXIT="$?"
  [ ! -z "$2" ] && local OK="$2" || local OK="Command executed successfully"
  [ ! -z "$3" ] && local FAIL="$3" || local FAIL="${PREV:-The previous command} has failed"
  [ ! -z "$4" ] && local FAIL="$3" || local FAIL="$3"
  if [ "$EXIT" -eq 0 ]; then
    printf_success "$OK"
    return 0
  else
    if [ -z "$4" ]; then
      printf_error "$FAIL"
    else
      printf_error "$FAIL: $PREV"
    fi
    return 1
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
  printf_question "$1 (y/N) "
  read -re -n 1 "REPLY"
}
##################################################################################################
__curl() { __am_i_online && curl --disable -LSs --connect-timeout 3 --retry 0 "$@"; }
__start() {
  sleep .2 && "$@" &>/dev/null &
  disown
}
die() { echo -e "$1" exit ${2:9999}; }
killpid() { devnull kill -9 "$(pidof "$1")"; }
running() { ps ux | grep "$1" | grep -vq 'grep ' &>/dev/null && return 1 || return 0; }
hostname2ip() { getent hosts "$1" | cut -d' ' -f1 | head -n1 || nslookup "$1" 2>/dev/null | grep Address: | awk '{print $2}' | grep -vE '#|:' | grep ^ || return 1; }
set_trap() { trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"; }
getuser() { [ -z "$1" ] && cut -d: -f1 /etc/passwd | grep "$USER" || cut -d: -f1 /etc/passwd | grep "$1"; }
#system_service_active "list of services to check"
system_service_active() {
  for service in "$@"; do
    if [ "$(systemctl show -p ActiveState $service | cut -d'=' -f2)" == active ]; then
      return 0
    else
      return 1
    fi
  done
}
#system_service_running "list of services to check"
system_service_running() {
  for service in "$@"; do
    if systemctl status $service 2>/dev/null | grep -Fq running; then
      return 0
    else
      return 1
    fi
  done
}
#system_service_exists "servicename"
system_service_exists() {
  for service in "$@"; do
    if sudo systemctl list-units --full -all | grep -Fq "$service.service" || sudo systemctl list-units --full -all | grep -Fq "$service.socket"; then return 0; else return 1; fi
    setexitstatus $?
  done
  set --
}
#system_service_enable "servicename"
system_service_enable() {
  for service in "$@"; do
    if system_service_exists "$service"; then devnull "sudo systemctl enable --now -f $service"; fi
    setexitstatus $?
  done
  set --
}
#system_service_disable "servicename"
system_service_disable() {
  for service in "$@"; do
    if system_service_exists "$service"; then devnull "sudo systemctl disable --now -f $service"; fi
    setexitstatus $?
  done
  set --
}
#system_service_start "servicename"
system_service_start() {
  for service in "$@"; do
    if system_service_exists "$service"; then devnull "sudo systemctl start $service"; fi
    setexitstatus $?
  done
  set --
}
#system_service_stop "servicename"
system_service_stop() {
  for service in "$@"; do
    if system_service_exists "$service"; then devnull "sudo systemctl stop $service"; fi
    setexitstatus $?
  done
  set --
}
#system_service_restart "servicename"
system_service_restart() {
  for service in "$@"; do
    if system_service_exists "$service"; then devnull "sudo systemctl restart $service"; fi
    setexitstatus $?
  done
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
  [ -n "$1" ] && local myappdir="$1" || local myappdir="$APPDIR"
  [ -n "$2" ] && local myappname="$2" || local myappname="$APPNAME"
  local downloaddir="$INSTDIR"
  local logdir="${LOGDIR:-$HOME/.local/log}/backups/${SCRIPTS_PREFIX:-apps}"
  local curdate="$(date +%Y-%m-%d-%H-%M-%S)"
  local filename="$myappname-$curdate.tar.gz"
  local backupdir="${MY_BACKUP_DIR:-$HOME/.local}/backups/${SCRIPTS_PREFIX:-apps}/"
  local count="$(ls $backupdir/$myappname*.tar.gz 2>/dev/null | wc -l 2>/dev/null)"
  local rmpre4vbackup="$(ls $backupdir/$myappname*.tar.gz 2>/dev/null | head -n 1)"
  mkdir -p "$backupdir" "$logdir"
  if [ -d "$myappdir" ] && [ "$myappdir" != "$downloaddir" ] && [ ! -f "$APPDIR/.installed" ]; then
    echo -e " #################################" >>"$logdir/$myappname.log"
    echo -e "# Started on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    echo -e "# Backing up $myappdir" >>"$logdir/$myappname.log"
    echo -e "#################################" >>"$logdir/$myappname.log"
    tar cfzv "$backupdir/$filename" "$myappdir" >>"$logdir/$myappname.log" 2>>"$logdir/$myappname.log"
    echo -e "#################################" >>"$logdir/$myappname.log"
    echo -e "# Ended on $(date +'%A, %B %d, %Y %H:%M:%S')" >>"$logdir/$myappname.log"
    echo -e "#################################" >>"$logdir/$myappname.log"
    [ -f "$APPDIR/.installed" ] || rm_rf "$myappdir"
  fi
  if [ "$count" -gt "3" ]; then rm_rf $rmpre4vbackup; fi
}
##################################################################################################
broken_symlinks() { devnull find "$*" -xtype l -exec rm {} \;; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; else return 0; fi; }
rm_rf() { if [ -e "$1" ]; then devnull rm -Rf "$@"; else return 0; fi; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; else return 0; fi; }
ln_rm() {
  if [ -e "$1" ]; then
    devnull find -L $1 -mindepth 1 -maxdepth 1 -type l -exec rm -f {} \;
  fi
}
ln_sf() {
  [ -L "$2" ] && __rm_rf "$2" || true
  devnull ln -sf "$1" "$2"
}
mkd() {
  local dir="$*"
  for d in $dir; do
    if [ -f "$d" ]; then rm_rf "$d"; fi
    [ -d "$d" ] || mkdir -p "$d" &>/dev/null
  done
  return 0
}
replace() { find "$1" -not -path "$1/.git/*" -type f -exec sed -i "s#$2#$3#g" {} \; >/dev/null 2>&1; }
rmcomments() { sed 's/[[:space:]]*#.*//;/^[[:space:]]*$/d'; }
countwd() { cat "$@" | wc-l | rmcomments; }
urlcheck() { devnull curl --config /dev/null --connect-timeout 3 --retry 3 --retry-delay 1 --output /dev/null --silent --head --fail "$1"; }
urlinvalid() {
  if [ -z "$1" ]; then
    printf_red "Invalid URL"
    failexitcode
  else
    printf_red "Can't find $1"
    failexitcode
  fi
}
urlverify() { urlcheck "$1" || urlinvalid "$1"; }
symlink() { ln_sf "$1" "$2"; }
rm_link() { unlink "$1"; }
##################################################################################################
__am_i_online() {
  site="1.1.1.1"
  test_ping() {
    timeout 1 ping -c1 $site &>/dev/null
    pingExit=$?
  }
  test_http() {
    timeout 1 __curl --max-time 1 $site | grep -e "HTTP/[0123456789]" | grep "200" -n1 &>/dev/null
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
  return $exitCode
}
gem_exists() {
  local package="$1"
  if devnull gem query -i -n "$package"; then return 0; else return 1; fi
}
perl_exists() {
  local package="$1"
  if devnull perl -M$package -le 'print $INC{"$package/Version.pm"}' ||
    devnull perl -M$package -le 'print $INC{"$package.pm"}' ||
    devnull perl -M$package -le 'print $INC{"$package"}'; then
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
  local retries="${1:-}"
  local count=0
  shift
  until "$@"; do
    local exit=$?
    local wait=$((2 ** count))
    local count=$((count + 1))
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
  local EXITCODE="$?"
  test -n "$1" && test -z "${1//[0-9]/}" && local EXITCODE="$1" && shift 1
  if [ ! -z "$1" ]; then
    local PSUCCES="$1"
  elif [ ! -z "$SUCCES" ]; then
    local PSUCCES="$SUCCES"
  else
    local PSUCCES="Command successful"
  fi
  if [ ! -z "$2" ]; then
    local PERROR="$2"
  elif [ ! -z "$ERROR" ]; then
    local PERROR="$ERROR"
  else
    local PERROR="Last command failed to complete"
  fi
  if [ "$EXITCODE" -eq 0 ]; then
    printf_cyan "$PSUCCES"
  else
    printf_red "$PERROR"
  fi
  returnexitcode "$EXITCODE"
  return "$EXITCODE"
}
##################################################################################################
failexitcode() {
  local RETVAL="$?"
  test -n "$1" && test -z "${1//[0-9]/}" && local RETVAL="$1" && shift 1
  [ ! -z "$1" ] && local fail="$1" || local fail="Command has failed"
  [ ! -z "$2" ] && local success="$2" || local success=""
  if [ "$RETVAL" -ne 0 ]; then
    set -E
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
__getip 2>/dev/null
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
sudoreq() {
  if [[ $UID != 0 ]]; then
    printf_newline
    printf_error "Please run this script with sudo/root\n"
    exit 1
  fi
}
user_is_root() { if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then return 0; else return 1; fi; }
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
  local exitCode=$?
  if [ $exitCode -eq 0 ]; then
    sudoask || printf_green "Getting privileges successfull continuing" &&
      sudo -n true
  else
    printf_red "Failed to get privileges"
    return 1
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
    printf_red "You dont have access to sudo Please contact the syadmin for access"
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
  cat <(grep -F -i -v "$command" <(crontab -l)) <(echo "$job") | crontab - &>/dev/null
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
      printf_green "Removing $file from $WHOAMI crontab"
      crontab -l | grep -v -F "$file" | crontab - &>/dev/null
      printf_custom "2" "$file has been removed from automatically updating"
    else
      printf_green "Removing $file from root crontab"
      sudo crontab -l | grep -v -F "$file" | sudo crontab - &>/dev/null
      printf_custom "2" "$file has been removed from automatically updating"
    fi
    ;;

  add)
    shift 1
    [ -f "$file" ] || printf_exit "1" "Can not find $file"
    if [[ "$EUID" -ne 0 ]]; then
      local croncmd="logr"
      local additional='bash -c "am_i_online && sleep $(expr $RANDOM \% 300) && '$file' &"'
      printf_green "Adding $frequency $croncmd $additional to $WHOAMI crontab"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove"
    else
      local croncmd="logr"
      local additional='bash -c "am_i_online && sleep $(expr $RANDOM \% 300) && '$file' &"'
      printf_green "Adding $frequency $croncmd $additional to root crontab"
      sudo crontab -l | grep -qv -F "$croncmd"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove"
    fi
    ;;

  *)
    [ -f "$file" ] || printf_exit "1" "Can not find $file"
    if [[ "$EUID" -ne 0 ]]; then
      local croncmd="logr"
      local additional='bash -c "am_i_online && sleep $(expr $RANDOM \% 300) && '$file' &"'
      printf_green "Adding $frequency $croncmd $additional to $WHOAMI crontab"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove"
    else
      local croncmd="logr"
      local additional='bash -c "am_i_online && sleep $(expr $RANDOM \% 300) && '$file' &"'
      printf_green "Adding $frequency $croncmd $additional to root crontab"
      sudo crontab -l | grep -qv -F "$croncmd"
      addtocrontab "$frequency" "$croncmd" "$additional"
      printf_custom "2" "$file has been added to update automatically"
      printf_custom "3" "To remove run $file --cron remove"
    fi
    ;;
  esac
}
##################################################################################################
versioncheck() {
  if [ -f "$INSTDIR/version.txt" ]; then
    printf_green "Checking for updates"
    local NEWVERSION="$(echo $APPVERSION | grep -v "#" | tail -n 1)"
    local OLDVERSION="$(grep -v "#" $INSTDIR/version.txt | tail -n 1)"
    if [ "$NEWVERSION" == "$OLDVERSION" ]; then
      printf_green "No updates available currentversion is $OLDVERSION"
    else
      printf_blue "There is an update available"
      printf_blue "New version is $NEWVERSION and currentversion is $OLDVERSION"
      printf_question_timeout "Would you like to update" [y/N]
      read -n 1 -s choice
      echo ""
      if [[ $choice == "y" || $choice == "Y" ]]; then
        [ -f "$INSTDIR/install.sh" ] && bash -c "$INSTDIR/install.sh" && echo ||
          git -C "$INSTDIR" pull -q &&
          printf_green "Updated to $NEWVERSION" ||
          printf_red "Failed to update"
      else
        printf_cyan "You decided not to update"
      fi
    fi
  fi
  exit $?
}
##################################################################################################
scripts_check() {
  if __am_i_online; then
    if ! cmd_exists "pkmgr" && [ ! -f ~/.noscripts ]; then
      printf_red "Please install my scripts repo - requires root/sudo"
      printf_question_timeout "Would you like to do that now" [y/N]
      read -n 1 -s choice && echo ""
      if [[ $choice == "y" || $choice == "Y" ]]; then
        urlverify $REPO/installer/raw/master/install.sh &&
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
    local myappdir="${2:-$INSTDIR}"
    [ -d "$myappdir/.git" ] || rm_rf "$myappdir"
    devnull git clone --depth=1 -q --recursive "$repo" "$myappdir"
  fi
}
##################################################################################################
git_update() {
  local myappdir="${1:-$INSTDIR}"
  local exitCode=""
  if __am_i_online; then
    local repo="$(git remote -v | grep fetch | head -n 1 | awk '{print $2}')"
    devnull git -C "$myappdir" reset --hard &&
      devnull git -C "$myappdir" pull --recurse-submodules -fq &&
      devnull git -C "$myappdir" submodule update --init --recursive -q &&
      devnull git -C "$myappdir" reset --hard -q && exitCode=0 || exitCode=1
    if [ "$exitCode" -ne 0 ] && [ -n "$repo" ] && [ ! -d "$myappdir/.git" ]; then
      rm_rf "$myappdir"
      git_clone "$repo" "$myappdir"
    fi
  fi
}
##################################################################################################

dotfilesreqcmd() {
  local gitrepo="$REPO"
  local conf="${1:-$conf}"
  if __am_i_online; then
    urlverify "$gitrepo/$conf/raw/master/install.sh" &&
      sudo_user bash -c "$(__curl $gitrepo/$conf/raw/master/install.sh)" || return 1
  fi
}
dotfilesreqadmincmd() {
  local gitrepo="$REPO"
  local conf="${1:-$conf}"
  if __am_i_online; then
    urlverify "$gitrepo/$conf/raw/master/install.sh" &&
      sudo_root bash -c "$(__curl $gitrepo/$conf/raw/master/install.sh)" || return 1
  fi
}
##################################################################################################
dotfilesreq() {
  if __am_i_online; then
    if cmd_exists pkmgr; then
      local conf=""
      local confdir="$USRUPDATEDIR"
      local LISTARRAY="$*"
      for conf in ${LISTARRAY[*]}; do
        if [ ! -f "$confdir/$conf" ] && [ ! -f "$TMPDIR/$conf.inst.tmp" ]; then
          execute "dotfilesreqcmd $conf" "Installing required dotfile $conf"
        fi
      done
      rm_rf $TMPDIR/*.inst.tmp
    fi
  fi
}
dotfilesreqadmin() {
  if __am_i_online; then
    if cmd_exists pkmgr; then
      local conf=""
      local confdir="$SYSUPDATEDIR"
      local LISTARRAY="$*"
      for conf in ${LISTARRAY[*]}; do
        if [ ! -f "$confdir/$conf" ] && [ ! -f "$TMPDIR/$conf.inst.tmp" ]; then
          execute "dotfilesreqadmincmd $conf" "Installing required dotfile $conf"
        fi
      done
      rm_rf $TMPDIR/*.inst.tmp
    fi
  fi
}
##################################################################################################
install_required() {
  if __am_i_online; then
    [[ $# -eq 0 ]] && return 0
    # local MISSING=""
    # local cmd=""
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
  [[ -z "$1" ]] && return 0
  if __am_i_online; then
    local MISSING=""
    local cmd=""
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
  [[ -z "$1" ]] && return 0
  if __am_i_online; then
    local MISSING=""
    local cmd=""
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
  [[ -z "$1" ]] && return 0
  if __am_i_online; then
    local MISSING=""
    local cmd=""
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
  [[ -z "$1" ]] && return 0
  if __am_i_online; then
    local MISSING=""
    local cmd=""
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
  [[ -z "$1" ]] && return 0
  if __am_i_online; then
    local MISSING=""
    local cmd=""
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
  [[ -z "$1" ]] && return 0
  if __am_i_online; then
    local MISSING=""
    local cmd=""
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
  local -r MSG="${2:-$1} "
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

supported_os() {
  for OSes in "$@"; do
    local app=${APPNAME:-$PROG}
    if_os $OSes || printf_exit 1 1 "$app does not support your OS"
    printf_newline
  done
}

unsupported_oses() {
  for OSes in "$@"; do
    if [[ "$(echo $OSes | tr '[:upper:]' '[:lower:]')" =~ $(os_support) ]]; then
      printf_red "$(os_support $OSes) is not supported"
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
###################### setup folders - user ######################
user_installdirs() {
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    INSTALL_TYPE=user
    if [[ $(uname -s) =~ Darwin ]]; then HOME="/usr/local/home/root"; else HOME="${HOME}"; fi
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="/usr/local/bin"
    SYSCONF="/usr/local/etc"
    SYSSHARE="/usr/local/share"
    SYSLOGDIR="/usr/local/log"
    BACKUPDIR="$HOME/.local/backups"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$SHARE/themes"
    ICONDIR="$SHARE/icons"
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="/Library/Fonts"; else FONTDIR="$SHARE/fonts"; fi
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="${WALLPAPERS:-$SYSSHARE/wallpapers}"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  else
    INSTALL_TYPE=user
    HOME="${HOME}"
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="$HOME/.local/bin"
    SYSCONF="$HOME/.config"
    SYSSHARE="$HOME/.local/share"
    SYSLOGDIR="$HOME/.local/log"
    BACKUPDIR="$HOME/.local/backups"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$SHARE/themes"
    ICONDIR="$SHARE/icons"
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="$HOME/Library/Fonts"; else FONTDIR="$SHARE/fonts"; fi
    FONTCONF="$SYSCONF/fontconfig/conf.d"
    CASJAYSDEVSHARE="$SHARE/CasjaysDev"
    CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
    WALLPAPERS="$HOME/.local/share/wallpapers"
    USRUPDATEDIR="$SHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  fi
  APPDIR="${APPDIR:-}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  REPORAW="${REPORAW:-$DFMGRREPO/$APPNAME/raw}"
  installtype="user_installdirs"
  git_repo_urls
}
###################### setup folders - system ######################
system_installdirs() {
  APPNAME="${APPNAME:-installer}"
  if [[ $(id -u) -eq 0 ]] || [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
    if [[ $(uname -s) =~ Darwin ]]; then HOME="/usr/local/home/root"; else HOME="${HOME}"; fi
    BACKUPDIR="$HOME/.local/backups"
    BIN="/usr/local/bin"
    CONF="/usr/local/etc"
    SHARE="/usr/local/share"
    LOGDIR="/usr/local/log"
    STARTUP="/dev/null"
    SYSBIN="/usr/local/bin"
    SYSCONF="/usr/local/etc"
    SYSSHARE="/usr/local/share"
    SYSLOGDIR="/usr/local/log"
    COMPDIR="/etc/bash_completion.d"
    THEMEDIR="/usr/local/share/themes"
    ICONDIR="/usr/local/share/icons"
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="/Library/Fonts"; else FONTDIR="/usr/local/share/fonts"; fi
    FONTCONF="/usr/local/share/fontconfig/conf.d"
    CASJAYSDEVSHARE="/usr/local/share/CasjaysDev"
    CASJAYSDEVSAPPDIR="/usr/local/share/CasjaysDev/apps"
    WALLPAPERS="/usr/local/share/wallpapers"
    USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  else
    INSTALL_TYPE=system
    HOME="${HOME:-/home/$WHOAMI}"
    BACKUPDIR="${BACKUPS:-$HOME/.local/backups}"
    BIN="$HOME/.local/bin"
    CONF="$HOME/.config"
    SHARE="$HOME/.local/share"
    LOGDIR="$HOME/.local/log"
    STARTUP="$HOME/.config/autostart"
    SYSBIN="$HOME/.local/bin"
    SYSCONF="$HOME/.local/etc"
    SYSSHARE="$HOME/.local/share"
    SYSLOGDIR="$HOME/.local/log"
    COMPDIR="$HOME/.local/share/bash-completion/completions"
    THEMEDIR="$HOME/.local/share/themes"
    ICONDIR="$HOME/.local/share/icons"
    if [[ $(uname -s) =~ Darwin ]]; then FONTDIR="$HOME/Library/Fonts"; else FONTDIR="$HOME/.local/share/fonts"; fi
    FONTCONF="$HOME/.local/share/fontconfig/conf.d"
    CASJAYSDEVSHARE="$HOME/.local/share/CasjaysDev"
    CASJAYSDEVSAPPDIR="$HOME/.local/share/CasjaysDev/apps"
    WALLPAPERS="$HOME/.local/share/wallpapers"
    USRUPDATEDIR="$HOME/.local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
    SYSUPDATEDIR="$HOME/.local/share/CasjaysDev/apps/${SCRIPTS_PREFIX:-dfmgr}"
  fi
  APPDIR="${APPDIR:-}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  SCRIPTS_PREFIX="${SCRIPTS_PREFIX:-dfmgr}"
  REPORAW="${REPORAW:-$DFMGRREPO/$APPNAME/raw}"
  installtype="system_installdirs"
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
    mkd "$SHARE/applications"
    mkd "$SHARE/CasjaysDev/functions"
    mkd "$SHARE/wallpapers/system"
    user_is_root && mkd "$SYSUPDATEDIR"
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
  if [ -f "$INSTDIR/version.txt" ]; then
    local version="$(grep -v "#" "$INSTDIR/version.txt" | tail -n 1)"
  else
    local version="0000000"
  fi
  local GITREPO=""$REPO/$APPNAME""
  local APPVERSION="${APPVERSION:-$(__appversion)}"
  [ -n "$WHOAMI" ] && printf_info "WhoamI:                    $WHOAMI"
  [ -n "$INSTALL_TYPE" ] && printf_info "Install Type:              $INSTALL_TYPE"
  [ -n "$APPNAME" ] && printf_info "APP name:                  $APPNAME"
  [ -n "$APPDIR" ] && printf_info "APP dir:                   $APPDIR"
  [ -n "$INSTDIR" ] && printf_info "Downloaded to:             $INSTDIR"
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
    printf_yellow "Removing $APPNAME from your system"
    [ -d "$INSTDIR" ] && rm_rf "$INSTDIR"
    rm_rf "$APPDIR" &&
      rm_rf "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME" &&
      rm_rf "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" &&
      broken_symlinks $BIN $SHARE $COMPDIR $CONF
    getexitcode "$APPNAME has been removed"
  else
    printf_red "$APPNAME doesn't seem to be installed"
    return 1
  fi
}
##################################################################################################
show_optvars() {
  if [ "$1" = "--force" ]; then
    shift 1
    FORCE_INSTALL="true"
    export FORCE_INSTALL
  fi
  if [ "$1" = "--debug" ]; then
    shift 1
    __debugger "debug"
  fi

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
    printf_cyan "Go to $REPO/$APPNAME for help"
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
    printf_info "Downloaded to:             $INSTDIR"
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
    printf_info "Downloaded to:             $INSTDIR"
    printf_info "REPORAW:                   $REPO/$APPNAME/raw"
    printf_info "Prefix:                    $SCRIPTS_PREFIX"
    for PATHS in $(path_info); do
      printf_info "PATH:                      $PATHS"
    done
    exit $?
  fi

  if [ "$1" = "--installed" ]; then
    printf_green "User                               Group                              AppName"
    ls -l $CASJAYSDEVSAPPDIR/dotfiles | tr -s ' ' | cut -d' ' -f3,4,9 |
      sed 's# #                               #g' | grep -v "total." | printf_readline "5"
    exit $?
  fi
}
##################################################################################################
installer_noupdate() {
  if [ "$FORCE_INSTALL" = "true" ]; then
    rm_rf "$APPDIR/.installed" "$INSTDIR/.installed"
    return 0
  fi
  if [ "$1" != "--force" ]; then
    if [ -f "$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX/$APPNAME" ] ||
      [ -f "$APPDIR/.installed" ] || [ -f "$INSTDIR/.installed" ]; then
      APPDIR="$INSTDIR"
      ln_sf "$INSTDIR/install.sh" "$SYSUPDATEDIR/$APPNAME"
      printf_yellow "Updating of $APPNAME has been disabled"
      printf_yellow "This can be changed with the --force flag"
      printf_newline ''
      exit 0
    fi
  fi
}
##################################################################################################
__install_fonts() {
  if [ -d "$INSTDIR/fontconfig" ]; then
    local fontconfdir="$FONTCONF"
    ln_sf "$INSTDIR/fontconfig"/* "$fontconfdir/"
    cmd_exists fc-cache && fc-cache -f "$FONTCONF"
  fi
  if [ -d "$HOME/Library/Fonts" ]; then
    local fontdir="$HOME/Library/Fonts"
  else
    local fontdir="$FONTDIR"
  fi
  if [ -d "$INSTDIR/fonts" ]; then
    [ -d "$fontdir/$APPNAME" ] && rm_rf "$fontdir/$APPNAME"
    ln_sf "$INSTDIR/fonts"/* "$fontdir/"
    cmd_exists fc-cache && fc-cache -f "$FONTDIR"
  fi
}
__install_icons() {
  if [ -d "$INSTDIR/icons" ]; then
    local icondir="$ICONDIR"
    local icons="$(ls "$INSTDIR/icons" 2>/dev/null | wc -l)"
    if [ "$icons" != "0" ]; then
      fFiles="$(ls $INSTDIR/icons --ignore='.uuid')"
      for f in $fFiles; do
        ln_sf "$INSTDIR/icons/$f" "$icondir/$f"
        find "$ICONDIR/$f" -mindepth 1 -maxdepth 1 -type d | while read -r ICON; do
          if [ -f "$ICON/index.theme" ]; then
            cmd_exists gtk-update-icon-cache && gtk-update-icon-cache -f -q "$ICON"
          fi
        done
      done
    fi
  fi
  devnull find "$ICONDIR" -type d -exec chmod 755 {} \;
  devnull find "$ICONDIR" -type f -exec chmod 644 {} \;
  cmd_exists gtk-update-icon-cache && devnull gtk-update-icon-cache -q -t -f "$ICONDIR"
  return 0
}
__install_theme() {
  if [ -d "$INSTDIR/theme" ]; then
    local themedir="$THEMEDIR"
    local theme="$(ls "$INSTDIR/theme" 2>/dev/null | wc -l)"
    if [ "$theme" != "0" ]; then
      fFiles="$(ls $INSTDIR/theme --ignore='.uuid')"
      for f in $fFiles; do
        ln_sf "$INSTDIR/theme/$f" "$themedir/$f"
        find "$THEMEDIR" -mindepth 1 -maxdepth 2 -type d | while read -r THEME; do
          if [ -f "$THEME/index.theme" ]; then
            cmd_exists gtk-update-icon-cache && gtk-update-icon-cache -f -q "$THEME"
          fi
        done
      done
    fi
    ln_rm "$THEMEDIR"
  fi
  find "$THEMEDIR" -mindepth 1 -maxdepth 2 -type d -not -path "*/.git/*" | while read -r THEME; do
    if [ -f "$THEME/index.theme" ]; then
      cmd_exists gtk-update-icon-cache && gtk-update-icon-cache -f -q "$THEME"
    fi
  done
  return 0
}
__install_wallpapers() {
  if [ -d "$INSTDIR/images" ]; then
    local wallpapers="$(ls $INSTDIR/images/ 2>/dev/null | wc -l)"
    if [ "$wallpapers" != "0" ]; then
      if [ "$INSTDIR" != "$APPDIR" ] && [ -e "$APPDIR" ]; then rm_rf "$APPDIR"; fi
      mkd "$APPDIR"
      wallpaperFiles="$(ls $INSTDIR/images/)"
      for wallpaper in $wallpaperFiles; do
        ln_sf "$INSTDIR/images/$wallpaper" "$APPDIR/$wallpaper"
      done
    fi
  fi
  return 0
}
##################################################################################################
###################### devenv settings ######################
devenvmgr_install() {
  user_installdirs
  SCRIPTS_PREFIX="devenv"
  REPO="$DEVENVMGRREPO"
  REPORAW="$DEVENVMGRREPO/$APPNAME/raw"
  APPDIR="${APPDIR:-$SHARE/$SCRIPTS_PREFIX/$APPNAME}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ARRAY="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(<$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  user_is_root && mkd "$SYSUPDATEDIR"
  export installtype="devenvmgr_install"
}
######## Installer Functions ########
devenvmgr_run_init() {
  run_install_init "dev enviroment"
}
devenvmgr_run_post() {
  devenvmgr_install
  run_postinst_global
  [ -d "$APPDIR" ] && replace "$APPDIR" "/home/jason" "$HOME"
}
devenvmgr_install_version() {
  devenvmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
###################### dfmgr settings ######################
dfmgr_install() {
  user_installdirs
  SCRIPTS_PREFIX="dfmgr"
  REPO="$DFMGRREPO"
  REPORAW="$DFMGRREPO/$APPNAME/raw"
  APPDIR="${APPDIR:-$CONF/$APPNAME}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
  ARRAY="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(<$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="dfmgr_install"
}
######## Installer Functions ########
dfmgr_run_init() {
  run_install_init "configurations"
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
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
##################################################################################################
dockermgr_install() {
  user_installdirs
  #cmd_exists docker || printf_exit 1 1 "This requires docker, however, docker wasn't found"
  SCRIPTS_PREFIX="dockermgr"
  REPO="$DOCKERMGRREPO"
  REPORAW="$DOCKERMGRREPO/$APPNAME/raw"
  APPDIR="${APPDIR:-$SHARE/docker/$APPNAME}"
  INSTDIR="${INSTDIR:-$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  DATADIR="${SHARE/docker/data/$APPNAME:-/srv/docker/$APPNAME}"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
  ARRAY="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(<$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="dockermgr_install"
}
######## Installer Functions ########
dockermgr_run_init() {
  run_install_init "docker configurations"
}
dockermgr_run_post() {
  dockermgr_install
  run_postinst_global
  [ -d "$APPDIR" ] && replace "$APPDIR" "/home/jason" "$HOME"
}
dockermgr_install_version() {
  dockermgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
##################################################################################################
fontmgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="fontmgr"
  REPO="$FONTMGRREPO"
  REPORAW="$FONTMGRREPO/$APPNAME/raw"
  APPDIR="$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  INSTDIR="$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  FONTDIR="${FONTDIR:-$SHARE/fonts}"
  APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
  ARRAY="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(<$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="fontmgr_install"
}
######## Installer Functions ########
fontmgr_run_init() {
  run_install_init "fonts"
}
fontmgr_run_post() {
  fontmgr_install
  run_postinst_global
  __install_fonts
}
fontmgr_install_version() {
  fontmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
##################################################################################################
iconmgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="iconmgr"
  REPO="$ICONMGRREPO"
  REPORAW="$ICONMGRREPO/$APPNAME/raw"
  APPDIR="$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  INSTDIR="$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  ICONDIR="${ICONDIR:-$SHARE/icons}"
  APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
  ARRAY="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(<$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="iconmgr_install"
}
######## Installer Functions ########
iconmgr_run_init() {
  run_install_init "icons"
}
iconmgr_run_post() {
  iconmgr_install
  run_postinst_global
  __install_icons
}
iconmgr_install_version() {
  iconmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
generate_icon_index() {
  iconmgr_install
  ICONDIR="${ICONDIR:-$SHARE/icons}"
  cmd_exists fc-cache && fc-cache -f "$ICONDIR"
}
##################################################################################################
pkmgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="pkmgr"
  REPO="$PKMGRREPO"
  REPORAW="$PKMGRREPO/$APPNAME/raw"
  APPDIR="$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  INSTDIR="$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  REPODF="https://raw.githubusercontent.com/pkmgr/dotfiles/master"
  APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
  ARRAY="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(<$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="pkmgr_install"
}
######## Installer Functions ########
pkmgr_run_init() {
  run_install_init "packages"
}
pkmgr_run_post() {
  pkmgr_install
  run_postinst_global
}
pkmgr_install_version() {
  pkmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
##################################################################################################
systemmgr_install() {
  requiresudo "true"
  system_installdirs
  SCRIPTS_PREFIX="systemmgr"
  REPO="$SYSTEMMGRREPO"
  REPORAW="$SYSTEMMGRREPO/$APPNAME/raw"
  CONF="${SYSCONF:-/usr/local/etc}"
  SHARE="${SYSSHARE:-/usr/local/share}"
  APPDIR="${APPDIR:-/usr/local/etc/$APPNAME}"
  INSTDIR="${INSTDIR:-$SYSSHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME}"
  USRUPDATEDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
  APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
  ARRAY="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(<$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  if [ "$APPNAME" = "scripts" ] || [ "$APPNAME" = "installer" ]; then
    APPDIR="/usr/local/share/CasjaysDev/scripts"
    INSTDIR="/usr/local/share/CasjaysDev/scripts"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="systemmgr_install"
}
######## Installer Functions ########
systemmgr_run_init() {
  run_install_init "configurations"
}
systemmgr_run_post() {
  systemmgr_install
  run_postinst_global
}
systemmgr_install_version() {
  systemmgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
##################################################################################################
thememgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="thememgr"
  REPO="$THEMEMGRREPO"
  REPORAW="$THEMEMGRREPO/$APPNAME/raw"
  APPDIR="$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  INSTDIR="$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  THEMEDIR="${THEMEDIR:-$SHARE/themes}/$APPNAME"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
  ARRAY="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(<$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="thememgr_install"
}
generate_theme_index() {
  thememgr_install
}
######## Installer Functions ########
thememgr_run_init() {
  run_install_init "theme"
}
thememgr_run_post() {
  thememgr_install
  run_postinst_global
  __install_theme
  generate_theme_index
}
thememgr_install_version() {
  thememgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
##################################################################################################
wallpapermgr_install() {
  system_installdirs
  SCRIPTS_PREFIX="wallpapermgr"
  REPO="$WALLPAPERMGRREPO"
  REPORAW="$WALLPAPERMGRREPO/$APPNAME/raw"
  APPDIR="$SHARE/wallpapers/$APPNAME"
  INSTDIR="$SHARE/CasjaysDev/$SCRIPTS_PREFIX/$APPNAME"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/$SCRIPTS_PREFIX"
  APPVERSION="$(__appversion ${REPO:-https://github.com/$SCRIPTS_PREFIX}/$APPNAME/raw/master/version.txt)"
  ARRAY="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/array)"
  LIST="$(<$CASJAYSDEVDIR/helpers/$SCRIPTS_PREFIX/list)"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && APPDIR="${APPDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  [ "$APPNAME" = "$SCRIPTS_PREFIX" ] && INSTDIR="${INSTDIR//$APPNAME\/$SCRIPTS_PREFIX/$APPNAME}"
  if [ -f "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" ]; then
    APPVERSION="$(<$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME)"
  else
    APPVERSION="$currentVersion"
  fi
  mkd "$USRUPDATEDIR" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  export installtype="wallpapermgr_install"
}
######## Installer Functions ########
wallpapermgr_run_init() {
  run_install_init "wallpapers"
}
wallpapermgr_run_post() {
  wallpapermgr_install
  run_postinst_global
  __install_wallpapers
}
wallpapermgr_install_version() {
  wallpapermgr_install
  install_version
  # if [ -f "$INSTDIR/install.sh" ] && [ -f "$INSTDIR/version.txt" ]; then
  #   ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
  # fi
}
##################################################################################################
__main_installer_info() {
  if [ "$APPNAME" = "scripts" ] || [ "$APPNAME" = "installer" ]; then
    printf_cyan "Installing $APPNAME installer"
    APPNAME="scripts"
    APPDIR="/usr/local/share/CasjaysDev/scripts"
    INSTDIR="/usr/local/share/CasjaysDev/scripts"
    PLUGDIR="/usr/local/share/CasjaysDev/apps/$SCRIPTS_PREFIX"
    SYSBIN="/usr/local/bin"
  fi
  #printf_exit "A:$APPNAME D:$APPDIR I:$INSTDIR P:$PLUGDIR"
}
##################################################################################################
run_install_init() {
  local exitCode=0
  __main_installer_info
  printf ""
  if [ ! -f "$TMPDIR/$APPNAME.tmp" ]; then
    touch "$TMPDIR/$APPNAME.tmp"
    printf_yellow "Initializing the installer from"
    if [ -f "$INSTDIR/install.sh" ]; then
      printf_purple "${INSTDIR//$HOME/'~'}/install.sh"
      #bash -c "$INSTDIR/install.sh"
    else
      printf_yellow "Downloading to ${INSTDIR//$HOME/'~'}"
      printf_purple "$REPORAW/master/install.sh"
      if ! urlcheck "$REPORAW/master/install.sh"; then
        #bash -c "$(__curl $REPORAW/master/install.sh)"
        #else
        printf_error "Failed to initialize the installer from:"
        printf_exit "$REPORAW/master/install.sh\n"
      fi
    fi
  fi
  if [ -d "$APPDIR" ]; then
    printf_green "Updating ${1:-$APPNAME} in ${APPDIR//$HOME/'~'}"
  else
    printf_green "Installing ${1:-$APPNAME} to ${APPDIR//$HOME/'~'}"
  fi
  local exitCode=$?
  rm_rf "$TMPDIR/$APPNAME.tmp"
  [ "$exitCode" -eq 0 ] || exit 10
}
##################################################################################################
run_postinst_global() {
  $installtype
  # if [ "$APPDIR" != "$INSTDIR" ]; then
  #   ln_sf "$APPDIR" "$INSTDIR"
  #   if [ -d "$INSTDIR" ] && [ ! -e "$APPDIR" ]; then
  #     ln_sf "$APPDIR" "$INSTDIR"
  #   fi
  # fi
  if [[ "$APPNAME" = "scripts" ]] || [[ "$APPNAME" = "installer" ]]; then
    # Only run on the scripts install
    ln_rm "$SYSBIN/"
    ln_rm "$COMPDIR/"
    if [ -d "$INSTDIR/bin" ]; then
      local bin="$(ls $INSTDIR/bin/ 2>/dev/null | wc -l)"
      if [ "$bin" != "0" ]; then
        bFiles="$(ls $INSTDIR/bin)"
        for b in $bFiles; do
          chmod -Rf 755 "$INSTDIR/bin/$app"
          ln_sf "$INSTDIR/bin/$b" "$SYSBIN/$b"
        done
      fi
      ln_rm "$BIN/"
    fi
    cmd_exists updatedb && updatedb || return 0
  else
    # Run on everything else
    if [ "$APPDIR" != "$INSTDIR" ]; then
      [ -d "$INSTDIR/etc" ] && mkd "$APPDIR" && cp_rf "$INSTDIR/etc/." "$APPDIR/"
    fi

    if [ -d "$INSTDIR/backgrounds" ]; then
      mkdir -p "$WALLPAPERS/system"
      local wallpapers="$(ls $INSTDIR/backgrounds/ 2>/dev/null | wc -l)"
      if [ "$wallpapers" != "0" ]; then
        wallpaperFiles="$(ls $INSTDIR/backgrounds/)"
        for wallpaper in $wallpaperFiles; do
          cp_rf "$INSTDIR/backgrounds/$wallpaper" "$WALLPAPERS/system/$wallpaper"
        done
      fi
    fi

    if [ -d "$INSTDIR/startup" ]; then
      local autostart="$(ls $INSTDIR/startup/ 2>/dev/null | wc -l)"
      if [ "$autostart" != "0" ]; then
        startFiles="$(ls $INSTDIR/startup)"
        for start in $startFiles; do
          ln_sf "$INSTDIR/startup/$start" "$STARTUP/$start"
        done
      fi
      ln_rm "$STARTUP/"
    fi

    if [ -d "$INSTDIR/bin" ]; then
      local bin="$(ls $INSTDIR/bin/ 2>/dev/null | wc -l)"
      if [ "$bin" != "0" ]; then
        bFiles="$(ls $INSTDIR/bin)"
        for b in $bFiles; do
          chmod -Rf 755 "$INSTDIR/bin/$app"
          ln_sf "$INSTDIR/bin/$b" "$BIN/$b"
        done
      fi
      ln_rm "$BIN/"
    fi

    if [ -d "$INSTDIR/completions" ]; then
      local comps="$(ls $INSTDIR/completions/ 2>/dev/null | wc -l)"
      if [ "$comps" != "0" ]; then
        compFiles="$(ls $INSTDIR/completions)"
        for comp in $compFiles; do
          ln_sf "$INSTDIR/completions/$comp" "$COMPDIR/$comp"
        done
      fi
      ln_rm "$COMPDIR/"
    fi

    if [ -d "$INSTDIR/applications" ]; then
      local apps="$(ls $INSTDIR/applications/ 2>/dev/null | wc -l)"
      if [ "$apps" != "0" ]; then
        aFiles="$(ls $INSTDIR/applications)"
        for a in $aFiles; do
          ln_sf "$INSTDIR/applications/$a" "$SHARE/applications/$a"
        done
      fi
      ln_rm "$SHARE/applications/"
    fi
    [ "$installtype" = "fontmgr_install" ] || __install_fonts
    [ "$installtype" = "iconmgr_install" ] || __install_icons
    [ "$installtype" = "thememgr_install" ] || __install_theme
  fi
  # Permission fix
  ensure_perms
}
##################################################################################################
install_version() {
  printf_blue "$ICON_GOOD installing version info"
  $installtype
  mkd "$CASJAYSDEVSAPPDIR/dotfiles" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX"
  if [ "$APPNAME" = "installer" ] || [ "$APPNAME" = "scripts" ]; then
    ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/scripts"
    ln_sf "$INSTDIR/version.txt" "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-scripts"
  else
    [ -f "$APPDIR/version.txt" ] && ln_sf "$APPDIR/version.txt" "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME"
    [ -f "$APPDIR/install.sh" ] && ln_sf "$APPDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
    if [ "$APPDIR" != "$INSTDIR" ]; then
      [ -f "$INSTDIR/version.txt" ] && ln_sf "$INSTDIR/version.txt" "$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME"
      [ -f "$INSTDIR/install.sh" ] && ln_sf "$INSTDIR/install.sh" "$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"
    fi
  fi
}
##################################################################################################
run_exit() {
  $installtype
  printf_yellow "$ICON_GOOD Running exit commands"
  [ -e "$APPDIR/$APPNAME" ] || rm_rf "$APPDIR/$APPNAME"
  [ -e "$INSTDIR/$APPNAME" ] || rm_rf "$INSTDIR/$APPNAME"
  if [ -d "$APPDIR" ] && [ ! -f "$APPDIR/.installed" ]; then
    date '+Installed on: %m/%d/%y @ %H:%M:%S' >"$APPDIR/.installed" 2>/dev/null
  fi
  if [ -d "$INSTDIR" ] && [ ! -f "$INSTDIR/.installed" ]; then
    date '+Installed on: %m/%d/%y @ %H:%M:%S' >"$INSTDIR/.installed" 2>/dev/null
  fi
  if [ -f "$TMPDIR/$APPNAME.inst.tmp" ]; then rm_rf "$TMPDIR/$APPNAME.inst.tmp"; fi
  if [ -f "/tmp/$SCRIPTSFUNCTFILE" ]; then rm_rf "/tmp/$SCRIPTSFUNCTFILE"; fi
  local exitCode+=$?
  getexitcode "$APPNAME has been installed" "$APPNAME installer has encountered an error: Check the URL"
  printf_newline
  exit "${EXIT:-$?}"
}
##################################################################################################
run_install_list() {
  if [ -d "$USRUPDATEDIR" ] && [ -n "$(ls -A "$USRUPDATEDIR/$1" 2>/dev/null)" ]; then
    file="$(ls -A "$USRUPDATEDIR/$1" 2>/dev/null)"
    if [ -f "$file" ]; then
      printf_green "Information about $1: $(bash -c "$file --version")"
    else
      printf_exit "File was not found is it installed?"
      exit
    fi
  else
    declare -a LSINST="$(ls "$USRUPDATEDIR/" 2>/dev/null)"
    if [ -z "$LSINST" ]; then
      printf_red "No dotfiles are installed"
      exit
    else
      for df in ${LSINST[*]}; do
        printf_green "$df"
      done
    fi
  fi
}
##################################################################################################
# Versioning
__appversion() {
  if [ -f "$INSTDIR/version.txt" ]; then
    local localVersion="$(<$INSTDIR/version.txt)"
  else
    local localVersion="$localVersion"
  fi
  __curl "${1:-$REPORAW/master/version.txt}" || echo "$localVersion"
}

__required_version() {
  if [ -f "$CASJAYSDEVDIR/version.txt" ]; then
    local requiredVersion="${1:-$requiredVersion}"
    local currentVersion="${APPVERSION:-$currentVersion}"
    local rVersion="${requiredVersion//-git/}"
    local cVersion="${currentVersion//-git/}"
    if [ "$cVersion" -lt "$rVersion" ] && [ "$APPNAME" != "scripts" ] && [ "$SCRIPTS_PREFIX" != "systemmgr" ]; then
      printf_yellow "Requires version higher than $rVersion"
      printf_yellow "You will need to update for new features"
    fi
  fi
}
__required_version "$requiredVersion"
#[ "$installtype" = "devenvmgr_install" ] &&
devenvmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "dfmgr_install" ] &&
dfmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "dockermgr_install" ] &&
dockermgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "fontmgr_install" ] &&
fontmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "iconmgr_install" ] &&
iconmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "pkmgr_install" ] &&
pkmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "systemmgr_install" ] &&
systemmgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "thememgr_install" ] &&
thememgr_req_version() { __required_version "$1"; }
#[ "$installtype" = "wallpapermgr_install" ] &&
wallpapermgr_req_version() { __required_version "$1"; }
##################################################################################################
vdebug() {
  echo -e "VAR - "ARGS:$*""
  for path in "USER:$USER" "HOME:$HOME" "PREFIX:$SCRIPTS_PREFIX" "REPO:$REPO" "REPORAW:$REPORAW" \
    "CONF:$CONF" "SHARE:$SHARE" "INSTDIR:$INSTDIR" "APPDIR:$APPDIR" "USRUPDATEDIR:$USRUPDATEDIR" \
    "SYSUPDATEDIR:$SYSUPDATEDIR" "FONTDIR:$FONTDIR " "ICONDIR:$ICONDIR" "THEMEDIR:$THEMEDIR" \
    "$INSTDIR/version.txt:$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" \
    "$INSTDIR/install.sh:$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME" \
    "$APPDIR/version.txt:$CASJAYSDEVSAPPDIR/dotfiles/$SCRIPTS_PREFIX-$APPNAME" \
    "$APPDIR/install.sh:$CASJAYSDEVSAPPDIR/$SCRIPTS_PREFIX/$APPNAME"; do
    echo -e "VAR - $path"
  done
}
__debugger() {
  if [ "$1" = "debug" ]; then
    shift 1 && set -Ex
    export debug=true
    export LOGDIR_DEBUG="${LOGDIR:-/tmp/$USER}/debug"
    mkdir -p "$LOGDIR_DEBUG"
    rm_rf "$LOGDIR_DEBUG/$APPNAME.log" "$LOGDIR_DEBUG/$APPNAME.err"
    touch "$LOGDIR_DEBUG/$APPNAME.log" "$LOGDIR_DEBUG/$APPNAME.err"
    chmod -Rf 755 "$LOGDIR_DEBUG"
    vdebug "$*" >>"$LOGDIR_DEBUG/$APPNAME.log"
    exec 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0
    devnull() { "$@" 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0; }
    devnull1() { "$@" 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0; }
    devnull2() { "$@" 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0; }
    execute() { $1 2>>"$LOGDIR_DEBUG/$APPNAME.err" >>"$LOGDIR_DEBUG/$APPNAME.log" >&0 && set --; }
  fi
}
#set_trap "EXIT" "install_packages"
#set_trap "EXIT" "install_required"
#set_trap "EXIT" "install_python"
#set_trap "EXIT" "install_perl"
#set_trap "EXIT" "install_pip"
#set_trap "EXIT" "install_cpan"
#set_trap "EXIT" "install_gem"
# end
