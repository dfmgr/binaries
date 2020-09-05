#!/usr/bin/env bash

APPNAME="$(basename $0)"

set +eE
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        :
# @Created     : Wed, Aug 05, 2020, 02:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description :
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

xbps-install -Syu -y
xbps-install -Sy git sudo curl wget -y

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set functions

SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/master/functions}"
SCRIPTSFUNCTDIR="${SCRIPTSAPPFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-applications.bash}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f "$PWD/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/functions/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
else
  mkdir -p "/tmp/CasjaysDev/functions"
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/CasjaysDev/functions/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/CasjaysDev/functions/$SCRIPTSFUNCTFILE"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set options

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# main program

sudo bash -c "$(curl -LSs https://github.com/dfmgr/installer/raw/master/install.sh)"
reqpkgs
pkmgr clean
pkmgr makecache
pkmgr update

INSTPKGS="chromium-browser cmake cmake-data cmatrix conky cowsay cscope curl dmenu exo-utils figlet filezilla firefox"
for installpkgs in $INSTPKGS; do
  pkmgr silent "$installpkgs"
  exitCode=$?
done

for pkg in neovim neofetch fish zsh tmux; do
  execute "sudo pkmgr install "$pkg"" " Installing $pkg"
done

systemmgr install --all
dfmgr install --all

sudo pkmgr update

echo $FUNCTDIR
ls -a $FUNCTDIR

echo $HOME
ls -a $HOME

echo ROOT
ls -a /

devnull install_how2

echo $HOME
ls -a $HOME

systemmgr install --all
dfmgr install --all

#/* vim set expandtab ts=2 sw=2 noai
