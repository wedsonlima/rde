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

echo -e "\nDependencies:"

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
#               Zsh
########################################

echo -e "\n\nInstall Zsh? y/N"
read option

# https://github.com/skwp/dotfiles
case ${option} in
'y'|'Y'|'s'|'S')

  sudo apt install zsh powerline fonts-powerline

  sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh `"

  ;;
*)
  echo -e "\n\nDone.\n\n:-D\n\n"
  ;;
esac

########################################
#               Flat-Remix
########################################

echo -e "\n\nInstall flat-remix? y/N"
read option

case ${option} in
'y'|'Y'|'s'|'S')

  git clone https://github.com/daniruiz/flat-remix
  git clone https://github.com/daniruiz/flat-remix-gtk

  mkdir -p ~/.icons && mkdir -p ~/.themes
  cp -r flat-remix/Flat-Remix* ~/.icons/ && cp -r flat-remix-gtk/Flat-Remix-GTK* ~/.themes/

  ;;
*)
  echo -e "\n\nDone.\n\n:-D\n\n"
  ;;
esac

########################################
#               DOCKER
########################################

echo -e "\n\nInstall DOCKER? y/N"
read option

# https://docs.docker.com/install/linux/docker-ce/ubuntu/
case ${option} in
'y'|'Y'|'s'|'S')

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

  ;;
*)
  echo -e "\n\nDone.\n\n:-D\n\n"
  ;;
esac

########################################
#               ASDF
########################################

echo -e "\n\nInstall ASDF? y/N"
read option

# https://asdf-vm.com/#/core-manage-asdf-vm
case ${option} in
'y'|'Y'|'s'|'S')

  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.4

  # bash

  echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
  echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

  source ~/.bashrc

  # zsh

  echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
  echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

  source ~/.zshrc

  echo -e "\n-- asdf / ruby"

  # https://github.com/asdf-vm/asdf-ruby
  asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git

  # asdf install ruby 2.4.4
  # asdf install ruby 2.5.3
  asdf install ruby 2.6.3

  if [[ -e $(which ruby) ]]; then
    asdf global ruby 2.6.3
  fi

  echo -e "\n-- asdf / node"

  # https://github.com/asdf-vm/asdf-nodejs
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

  asdf install nodejs 12.6.0
  asdf global nodejs 12.6.0

  ;;
*)
  echo -e "\n\nDone.\n\n:-D\n\n"
  ;;
esac

########################################
#               ngrok
########################################

echo -e "\n\nInstall ngrok? y/N"
read option

case ${option} in
'y'|'Y'|'s'|'S')

  wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
  unzip ./ngrok.zip
  echo -e "\n\n ngrok authtoken:"
  read authtoken
  ./ngrok authtoken authtoken

  ;;
*)
  echo -e "\n\nDone.\n\n:-D\n\n"
  ;;
esac

########################################
#               git - Config
########################################

echo -e "\n\nGit config account"
echo -e "\n\n username:"
read username; git config --global user.name ${username}

echo -e "\n\n email:"
read email; git config --global user.email ${email}

# git alias
git config --global alias.st status
# setting colors diff
git config --global color.ui true

echo -e "\n\nCreating ssh keys:"
ssh-keygen -t rsa -C ${email}

echo -e "\n\nSetting with GitHub? y/N"
read option

case ${option} in
'y'|'Y'|'s'|'S')
  echo -e "\n\nPaste this ssh key in your GitHub account:"
  cat ${HOME}/.ssh/id_rsa.pub
  echo -e "\n\nPress enter to continue"
  read waiting

  echo -e "\n\nTesting GitHub connection"

  ssh -T git@github.com
  ;;
*)
  echo -e "\n\nDone.\n\n:-D\n\n"
  ;;
esac

echo -e "\n\nSetting with BitBucket? y/N"
read option

case ${option} in
'y'|'Y'|'s'|'S')
  echo -e "\n\nPaste this ssh key in your BitBucket account:"
  cat ${HOME}/.ssh/id_rsa.pub
  echo -e "\n\nPress enter to continue"
  read waiting

  echo -e "\n\nTesting BitBucket connection"

  ssh -T git@bitbucket.org
  ;;
*)
  echo -e "\n\nDone.\n\n:-D\n\n"
  ;;
esac

########################################
#               Snaps
########################################

echo -e "\n\nInstall SNAPS? y/N"
read option

# https://snapcraft.io/store
case ${option} in
'y'|'Y'|'s'|'S')

  sudo snap install sublime-text --classic
  sudo snap install opera
  sudo snap install spotify
  sudo snap install postman
  sudo snap install slack --classic
  sudo snap install chromium

  echo -e "\n-- enpass"

  # https://www.enpass.io/support/kb/general/how-to-install-enpass-on-linux/
  echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
  wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo apt-key add -
  sudo apt update
  sudo apt install enpass

  ;;
*)
  echo -e "\n\nDone.\n\n:-D\n\n"
  ;;
esac

cd $ORIG_FOLDER

exit 0
