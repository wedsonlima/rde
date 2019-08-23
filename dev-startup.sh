#!/bin/bash

########################################################################
# Ubuntu dev environment
########################################################################

ORIG_FOLDER=$PWD
TMP_FOLDER=/tmp/dev-startup

mkdir -p $TMP_FOLDER && cd $TMP_FOLDER

########################################
#               Essentials
########################################

echo -e "\n Installing system dependencies..."

sudo apt install build-essential \
                  zlib1g \
                  zlib1g-dev \
                  libpq-dev \
                  libssl-dev \
                  libyaml-dev \
                  libxml2-dev \
                  libxslt1-dev \
                  libc6-dev \
                  libncurses5-dev \
                  libreadline-dev \
                  libtool \
                  ncurses-term \
                  make \
                  automake \
                  autoconf  \
                  libffi-dev \
                  unixodbc-dev \
                  silversearcher-ag \
                  fontconfig \
                  software-properties-common \
                  vim-gtk3 \
                  unzip \
                  imagemagick \
                  sed \
                  mawk \
                  curl \
                  openssl \
                  apt-transport-https \
                  ca-certificates \
                  ssh \
                  git \
                  tilix \
                  gnome-tweak-tool \
                  fonts-hack-ttf \
                  default-jdk \
                  postgresql-10 postgresql-contrib postgresql-server-dev-10 \
                  memcached

########################################
#               Flat-Remix
########################################

echo -e "\n Install flat-remix? [y/N]"
read option

case ${option} in
'y'|'Y'|'s'|'S')

  git clone https://github.com/daniruiz/flat-remix
  git clone https://github.com/daniruiz/flat-remix-gtk

  mkdir -p ~/.icons && mkdir -p ~/.themes
  cp -r flat-remix/Flat-Remix* ~/.icons/ && cp -r flat-remix-gtk/Flat-Remix-GTK* ~/.themes/

  echo -e "\n done."

  ;;
*)
  echo -e "\n That's fine."
  ;;
esac

########################################
#               DOCKER
########################################

echo -e "\n Install DOCKER? [y/N]"
read option

# https://docs.docker.com/install/linux/docker-ce/ubuntu/
case ${option} in
'y'|'Y'|'s'|'S')

  echo -e "\n DOCKER GPG"
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

  sudo apt update
  sudo apt install docker-ce

  DOCKER_RESPONSE=$(sudo docker run hello-world)

  if [[ -z $DOCKER_RESPONSE ]]; then
    echo 'Docker installation - ERROR'
  fi

  echo -e "\n done."

  ;;
*)
  echo -e "\n That's fine."
  ;;
esac

########################################
#               ASDF
########################################

echo -e "\n Install ASDF? [y/N]"
read option

# https://asdf-vm.com/#/core-manage-asdf-vm
case ${option} in
'y'|'Y'|'s'|'S')

  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.4

  # bash

  echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
  echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

  source ~/.bashrc

  echo -e "\n -- asdf / ruby"

  # https://github.com/asdf-vm/asdf-ruby
  asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git

  # asdf install ruby 2.4.4
  # asdf install ruby 2.5.3
  asdf install ruby 2.6.3

  if [[ -e $(which ruby) ]]; then
    asdf global ruby 2.6.3
  fi

  echo -e "\n -- asdf / node"

  # https://github.com/asdf-vm/asdf-nodejs
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

  asdf install nodejs 12.6.0
  asdf global nodejs 12.6.0

  echo -e "\n done."

  ;;
*)
  echo -e "\n That's fine."
  ;;
esac

########################################
#               Zsh
########################################
# needs ruby
echo -e "\n Install Zsh? [y/N]"
read option

# https://github.com/skwp/dotfiles
case ${option} in
'y'|'Y'|'s'|'S')

  sudo apt install zsh powerline fonts-powerline

  sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh `"

  echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
  echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

  # source ~/.zshrc

  echo -e "\n done."

  ;;
*)
  echo -e "\n That's fine."
  ;;
esac

########################################
#               ngrok
########################################

echo -e "\n Install ngrok? [y/N]"
read option

case ${option} in
'y'|'Y'|'s'|'S')

  wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
  unzip ./ngrok.zip
  echo -e "\n  ngrok authtoken:"
  read authtoken
  ./ngrok authtoken authtoken

  # making it globally available
  sudo mv ngrok /usr/local/bin

  echo -e "\n done."

  ;;
*)
  echo -e "\n That's fine."
  ;;
esac

########################################
#               git - Config
########################################

echo -e "\n Git config account"
echo -e "\n  username:"
read username; git config --global user.name ${username}

echo -e "\n  email:"
read email; git config --global user.email ${email}

# git alias
git config --global alias.st status
# setting colors diff
git config --global color.ui true

echo -e "\n Creating ssh keys:"
ssh-keygen -t rsa -C ${email}

echo -e "\n Setting with GitHub? [y/N]"
read option

case ${option} in
'y'|'Y'|'s'|'S')
  echo -e "\n Paste this ssh key in your GitHub account:"
  cat ${HOME}/.ssh/id_rsa.pub

  echo -e "\n Press enter to continue"
  read waiting

  echo -e "\n Testing GitHub connection"
  ssh -T git@github.com

  echo -e "\n done."
  ;;
*)
  echo -e "\n That's fine."
  ;;
esac

echo -e "\n Setting with BitBucket? [y/N]"
read option

case ${option} in
'y'|'Y'|'s'|'S')
  echo -e "\n Paste this ssh key in your BitBucket account:"
  cat ${HOME}/.ssh/id_rsa.pub

  echo -e "\n Press enter to continue"
  read waiting

  echo -e "\n Testing BitBucket connection"
  ssh -T git@bitbucket.org

  echo -e "\n done."

  ;;
*)
  echo -e "\n That's fine."
  ;;
esac

########################################
#               Snaps
########################################

echo -e "\n Install SNAPS? [y/N]"
read option

# https://snapcraft.io/store
case ${option} in
'y'|'Y'|'s'|'S')

  echo -e "\n -- sublime-text"
  sudo snap install sublime-text --classic

  echo -e "\n -- heroku"
  sudo snap install heroku --classic
  heroku login -i

  echo -e "\n -- opera"
  sudo snap install opera

  echo -e "\n -- postman"
  sudo snap install postman

  echo -e "\n -- slack"
  sudo snap install slack --classic

  echo -e "\n -- heroku"
  sudo snap install chromium

  echo -e "\n -- spotify"
  sudo snap install spotify

  echo -e "\n -- enpass"

  # https://www.enpass.io/support/kb/general/how-to-install-enpass-on-linux/
  echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
  wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo apt-key add -
  sudo apt update
  sudo apt install enpass

  echo -e "\n -- dropbox"

  wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
  bash .dropbox-dist/dropboxd

  echo -e "\n done."

  ;;
*)
  echo -e "\n That's fine."
  ;;
esac

########################################
#               STEAM
########################################

echo -e "\n Install STEAM? [y/N]"
read option

# https://store.steampowered.com/about/
case ${option} in
'y'|'Y'|'s'|'S')

  wget -O https://steamcdn-a.akamaihd.net/client/installer/steam.deb
  sudo dpkg -i steam_latest.deb

  echo -e "\n done."

  ;;
*)
  echo -e "\n That's fine."
  ;;
esac

cd $ORIG_FOLDER

exit 0
