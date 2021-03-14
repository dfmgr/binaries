#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="GEN_SCRIPT_GEN_SCRIPT_REPLACE_APPNAME"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : GEN_SCRIPT_GEN_SCRIPT_REPLACE_VERSION
# @Author        : GEN_SCRIPT_GEN_SCRIPT_REPLACE_AUTHOR
# @Contact       : GEN_SCRIPT_GEN_SCRIPT_REPLACE_EMAIL
# @License       : GEN_SCRIPT_GEN_SCRIPT_REPLACE_LICENSE
# @ReadME        : GEN_SCRIPT_GEN_SCRIPT_REPLACE_FILENAME --help
# @Copyright     : GEN_SCRIPT_GEN_SCRIPT_REPLACE_COPYRIGHT
# @Created       : GEN_SCRIPT_GEN_SCRIPT_REPLACE_DATE
# @File          : GEN_SCRIPT_GEN_SCRIPT_REPLACE_FILENAME
# @Description   : GEN_SCRIPT_GEN_SCRIPT_REPLACE_DESC
# @TODO          : GEN_SCRIPT_GEN_SCRIPT_REPLACE_TODO
# @Other         : GEN_SCRIPT_GEN_SCRIPT_REPLACE_OTHER
# @Resource      : GEN_SCRIPT_GEN_SCRIPT_REPLACE_RES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/master/functions}"
connect_test() { ping -c1 1.1.1.1 &>/dev/null || curl --disable -LSs --connect-timeout 3 --retry 0 --max-time 1 1.1.1.1 2>/dev/null | grep -e "HTTP/[0123456789]" | grep -q "200" -n1 &>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
elif connect_test; then
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
user_installdirs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults
APPNAME="${APPNAME:-GEN_SCRIPT_GEN_SCRIPT_REPLACE_FILENAME}"
APPDIR="${APPDIR:-$HOME/.config/$APPNAME}"
INSTDIR="${INSTDIR}"
DATADIR="${SHARE/docker/data/$APPNAME:-/srv/docker/$APPNAME}"
REPO="${DOCKERMGRREPO:-https://github.com/dockermgr/$APPNAME}"
REPORAW="${REPORAW:-$REPO/raw}"
APPVERSION="$(__appversion $REPORAW/master/version.txt)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup plugins
PLUGNAMES=""
PLUGDIR="${SHARE:-$HOME/.local/share}/$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Require a version higher than
dockermgr_req_version "$APPVERSION"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the dockermgr function
dockermgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script options IE: --help --version
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# initialize the installer
dockermgr_run_init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup
__dockermgr_main() {
  mkdir -p "$DATADIR"/{data,config}
  chmod -Rf 777 "$DATADIR"

  if docker ps -a | grep "GEN_SCRIPT_GEN_SCRIPT_REPLACE_APPNAME" >/dev/null 2>&1; then
    docker pull GEN_SCRIPT_GEN_SCRIPT_REPLACE_APPNAME && docker restart "GEN_SCRIPT_GEN_SCRIPT_REPLACE_APPNAME"
  else
    docker run -d \
      --name="GEN_SCRIPT_GEN_SCRIPT_REPLACE_APPNAME" \
      --hostname "GEN_SCRIPT_GEN_SCRIPT_REPLACE_APPNAME" \
      --restart=always \
      --privileged \
      -p 4040:80 \
      -v "$DATADIR/data":/GEN_SCRIPT_GEN_SCRIPT_REPLACE_APPNAME/data \
      GEN_SCRIPT_GEN_SCRIPT_REPLACE_APPNAME
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# execute main function
__dockermgr_main
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create version file
dockermgr_install_version
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# exit
run_exit
# end
