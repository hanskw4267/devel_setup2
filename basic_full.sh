#! /usr/bin/env bash

#
# basic_full.sh
#
# Created on Tue Oct 05 2021 16:42:48
#
# Description:
# Post install script to setup a linux development environment
#   
# Copyright (c) 2021 Hans Kurnia
#

source $(dirname "${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}")/utils.sh
root_guard
# ------------------------------------------------------------------------------

source $(dirname "${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}")/basic_minimal.sh

ret=$?
if [[ "${ret}" -ne 0 ]] ; then
  exit 255
fi

print_msg "Continuing install for extra tools"

apt_install "snapd"
apt_install "flameshot"

snap_install "spotify"
snap_install "slack --classic"
snap_install "telegram-desktop"
snap_install "discord"
snap_install "teams"

if ask_user "Do you wish to install google chrome??" ; then
  echo "Installing chrome"
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome-stable_current_amd64.deb
  rm ./google-chrome-stable_current_amd64.deb
else
  echo "Okay, no problem. :) Let's move on!"
  echo "Skipping google chrome"
fi

if ask_user "Do you wish to install teamviewer??" ; then
  echo "Installing teamviewer"
  wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
  sudo apt install ./teamviewer_amd64.deb
  rm ./teamviewer_amd64.deb
else
  echo "Okay, no problem. :) Let's move on!"
  echo "Skipping teamviewer"
fi

if ask_user "Do you wish to install zoom??" ; then
  echo "Installing zoom"
  wget https://zoom.us/client/latest/zoom_amd64.deb
  sudo apt install -y ./zoom_amd64.deb
  rm ./zoom_amd64.deb
else
  echo "Okay, no problem. :) Let's move on!"
  echo "Skipping zoom"
fi

if ask_user "Do you wish to install pyenv??" ; then
  echo "Installing pyenv"

  print_msg "Installing pyenv dependencies"
  sudo apt install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

  export PYENV_ROOT $HOME/.pyenv
  export PATH $PYENV_ROOT/bin:$PATH

  sed -Ei -e '/^([^#]|$)/ {a \
  export PYENV_ROOT="$HOME/.pyenv"
  a \
  export PATH="$PYENV_ROOT/bin:$PATH"
  a \
  ' -e ':a' -e '$!{n;ba};}' ~/.profile
  echo 'eval "$(pyenv init --path)"' >>~/.profile
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc

  source ~/.profile
  source ~/.bashrc

  curl https://pyenv.run | bash
  pyenv update

else
  echo "Okay, no problem. :) Let's move on!"
  echo "Skipping Pyenv"
fi

if ask_user "Do you wish to install kicad 6.0??" ; then
  echo "Installing kicad 6.0"

  sudo apt install -y software-properties-common
  sudo add-apt-repository --yes ppa:kicad/kicad-6.0-releases
  sudo apt update
  sudo apt install -y --install-recommends kicad

else
  echo "Okay, no problem. :) Let's move on!"
  echo "Skipping kicad"
fi

if ask_user "Do you wish to install Virtualbox 6.1??" ; then
  echo "Installing Virtualbox 6.1"

  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox-2016.list
  wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
  sudo apt -y update
  sudo apt -y install virtualbox-6.1 virtualbox-ext-pack virtualbox-guest-additions-iso
else
  echo "Okay, no problem. :) Let's move on!"
  echo "Skipping kicad"
fi

print_msg "cleaning with autoremove"
sudo apt autoremove -y

print_msg "Full Basic Development Setup Done :D"