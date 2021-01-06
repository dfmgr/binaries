#!/usr/bin/env bash

APPNAME="travis-ci.sh"

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

# main program
if [[ "$OSTYPE" =~ ^linux ]]; then
  echo -e "\n\t\t-----------------------------------------------------\n"
  printf_green "Setting up git for push"
  curl -LSs -H "Authorization: token ${GITHUB_API_KEY}" "https://${PERSONAL_GIT_REPO}/etc/skel/.config/git/git-credentials" -o "$HOME/.config/git/git-credentials" >/dev/null 2>&1
  git clone -q https://github.com/casjay-dotfiles/scripts "$HOME/push-scripts" >/dev/null 2>&1
  git -C "$HOME/push-scripts" push -q -f https://${GITHUB_API_KEY}@github.com/pkmgr/installer >/dev/null 2>&1 && printf_green "Successfully pushed to pkmgr/installer" || printf_red "Failed to push to pkmgr/installer"
  git -C "$HOME/push-scripts" push -q -f https://${GITHUB_API_KEY}@github.com/dfmgr/installer >/dev/null 2>&1 && printf_green "Successfully pushed to dfmgr/installer" || printf_red "Failed to push to dfmgr/installer"
  git -C "$HOME/push-scripts" push -q -f https://${GITHUB_API_KEY}@github.com/iconmgr/installer >/dev/null 2>&1 && printf_green "Successfully pushed to iconmgr/installer" || printf_red "Failed to push to iconmgr/installer"
  git -C "$HOME/push-scripts" push -q -f https://${GITHUB_API_KEY}@github.com/fontmgr/installer >/dev/null 2>&1 && printf_green "Successfully pushed to fontmgr/installer" || printf_red "Failed to push to fontmgr/installer"
  git -C "$HOME/push-scripts" push -q -f https://${GITHUB_API_KEY}@github.com/thememgr/installer >/dev/null 2>&1 && printf_green "Successfully pushed to thememgr/installer" || printf_red "Failed to push to thememgr/installer"
  git -C "$HOME/push-scripts" push -q -f https://${GITHUB_API_KEY}@github.com/systemmgr/installer >/dev/null 2>&1 && printf_green "Successfully pushed to systemmgr/installer" || printf_red "Failed to push to systemmgr/installer"
  git -C "$HOME/push-scripts" push -q -f https://${GITHUB_API_KEY}@github.com/wallpapermgr/installer >/dev/null 2>&1 && printf_green "Successfully pushed to wallpapermgr/installer" || printf_red "Failed to push to wallpapermgr/installer"
fi

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Testing scripts install"
sudo bash -c "$(curl -LSs https://github.com/dfmgr/installer/raw/master/install.sh)"

#echo -e "\n\t\t-----------------------------------------------------\n"
#printf_green "Running system upgrade - pkmgr silent-upgrade"
#sudo pkmgr silent-upgrade

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Installing packages"
for installpkgs in cmake cmake-data cmatrix conky cowsay cscope curl dmenu exo-utils figlet neovim neofetch fish zsh tmux; do
  execute "sudo pkmgr silent "$installpkgs"" "Installing $installpkgs"
  exitCode=$?
done

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Updating the installer"
sudo systemmgr install installer

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Testing systemmgr"
systemmgr install cron ssh

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Testing dfmgr"
dfmgr install bashtop neofetch

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Testing fontmgr"
fontmgr install hack

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Testing wallpapermgr"
wallpapermgr install casjay

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "printing pkmgr info"
pkmgr info

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Printing help"
./install.sh --help

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Printing version"
./install.sh --version

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Printing location"
./install.sh --location

echo -e "\n\t\t-----------------------------------------------------\n"
printf_green "Printing debug"
./install.sh --debug

echo -e "\n\n\t\t-----------------------------------------------------\n"
exit $?
## end
