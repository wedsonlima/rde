#! /bin/bash

########################################################################
# Ruby on Rails environment for Ubuntu with RVM and GIT
########################################################################

echo -e "\n---\nRuby on Rails environment for Ubuntu with RVM and GIT\n---\n"
echo -e "\nResolving dependencies:"

sudo apt-get install imagemagick sed mawk libpq-dev build-essential openssl libreadline6 libreadline6-dev curl git-core \
zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison \
postgresql-9.4 nodejs ssh

# sudo apt-get autoremove

echo -e "\n\nInstalling rvm"

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby; source $HOME/.rvm/scripts/rvm; rvm reload

# load rvm as a function
if [ -f ${HOME}/.bashrc ]; then
   echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bashrc
  source ${HOME}/.bashrc
elif [ -f ${HOME}/.bash_profile ]; then
   echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
  source ${HOME}/.bash_profile
else
  echo -e "\n\nNo bash file found"
  exit 1
fi

echo -e "\n\nInstalling RoR"
gem install rails --no-ri --no-rdoc

echo -e "\n\nSync with GitHub? y/N"
read option

case ${option} in
'y'|'Y'|'s'|'S')
  echo -e "\n\nConfiguring git account"
  echo -e "\n\nusername from GitHub:"
  read username; git config --global user.name ${username}

  echo -e "\n\nEmail account:"
  read email; git config --global user.email ${email}

  # git alias
  git config --global alias.st status
  # setting colors diff
  git config --global color.ui true

  # github keys

  echo -e "\n\nCreating ssh keys:"
  ssh-keygen -t rsa -C ${email}
  echo -e "\n\nPaste this ssh key in your GitHub account:"
  cat ${HOME}/.ssh/id_rsa.pub
  echo -e "\n\nPressione enter para continuar"
  read wating

  echo -e "\n\nTesting GitHub connection"

  ssh -T git@github.com
  ;;
*)
  echo -e "\n\nDone.\n\n:-D\n\n"
  ;;
esac

exit 0
