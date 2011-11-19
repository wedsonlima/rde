#!/bin/bash

########################################################################
# Ambiente de desenvolvimento em Ruby on Rails, utilizando RVM e git
########################################################################


echo -e "\n---\nInstalação do ambiente de desenvolvimento com git, rvm, ruby e solar\n---\n"
echo -e "\nInstalando dependencias:\n"

sudo apt-get install imagemagick curl bash sed mawk libxslt-dev libxml2-dev libpq-dev git-core git-doc gitg

echo -e "\n\nInstalando rvm:\n"
bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )

# load do rvm no shell como uma funcao
if [ -f ${HOME}/.bashrc ]; then
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bashrc
    source ${HOME}/.bashrc
elif [ -f ${HOME}/.bash_profile ]; then
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
    source ${HOME}/.bash_profile
else
    echo -e "\n\nNenhum arquivo de bash encontrado.\n\n"
    exit 1
fi

# definindo valores
ruby_version='1.9.3'
rails_version='3.0.7'
gemset_name='rails3'

echo -e "\n\nInstalando ruby ${ruby_version}:\n"
rvm install ${ruby_version}

echo -e "\n\nDefinindo RVM ${ruby_version}:\n"
rvm use ${ruby_version}

echo -e "\n\nCriando gemset '${gemset_name}' para o ruby ${ruby_version}:\n"
rvm --create ${ruby_version}@${gemset_name}

echo -e "\n\nInstalando o rails ${rails_version}:\n"
gem install rails -v ${rails_version} --no-rdoc --no-ri

# configurando conta do git
echo -e "Deseja configurar a sincronia deste computador com o Github? y/N"
read option

case ${option} in
'y'|'Y'|'s'|'S')
  echo -e "\n\nConfigurando conta do git"
  echo -e "\n\nNome de usuario do Github:"
  read username; git config --global user.name ${username}

  echo -e "\n\nConta de email do git:"
  read email; git config --global user.email ${email}

  # atalhos do git
  git config --global alias.st status
  # cores no diff
  git config --global color.branch auto
  git config --global color.diff auto
  git config --global color.status auto

  # criacao da chave ssh para uso no github

  echo -e "\n\nGerando chaves ssh para conexao no github(Necessario criar uma conta lah):"
  ssh-keygen -t rsa -C ${email}
  echo -e "\n\nAdicione esta chave no Github:"
  cat ${HOME}/.ssh/id_rsa.pub
  echo -e "\n\nPressione enter para continuar"
  read wating

  echo -e "\n\nTestando conexão ssh no Github"

  # testando ssh no github
  ssh -T git@github.com
  ;;
*)
  echo -e "\n\nInstalação e configuração do rvm(ruby, git e gemset) finalizada.\n\n:-D\n\n"
  ;;
esac

exit 0
