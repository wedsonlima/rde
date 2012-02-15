#!/bin/bash

########################################################################
# Ambiente de desenvolvimento em Ruby on Rails, utilizando RVM e git
########################################################################

# definindo versões e nome da gemset
ruby_version='1.9.3'
rails_version='3.0.11'
gemset_name='rails3'

# instalacao ou atualizacao dos pacotes de desenvolvimento
echo -e "\n---\nInstalação do ambiente de desenvolvimento com git, rvm, ruby e solar\n---\n"
echo -e "\nInstalando dependencias:"
sudo apt-get install imagemagick curl bash sed mawk libxslt-dev libxml2-dev libpq-dev git-core git-doc gitg

# verifica se o rvm já esta instalado e se é a versão mais atual
is_rvm_install=$(rvm --version 2> /dev/null > /dev/null; echo $?)

# instalando rvm
if [ ${is_rvm_install} -gt 0 ]; then
  echo -e "\n\nInstalando rvm"
  bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)

  # load do rvm no shell como uma funcao
  if [ -f ${HOME}/.bashrc ]; then
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bashrc
    source ${HOME}/.bashrc
  elif [ -f ${HOME}/.bash_profile ]; then
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
    source ${HOME}/.bash_profile
  else
    echo -e "\n\nNenhum arquivo de bash encontrado"
    exit 1
  fi

else
  echo -e "\n\nRVM já instalado"
fi

# verifica se a versao do ruby já está instalada
is_ruby_install=$(rvm use ${ruby_version} > /dev/null; echo $?)

if [ ${is_ruby_install} -gt 0 ]; then
  echo -e "\n\nInstalando ruby ${ruby_version}"
  rvm install ${ruby_version}
else
  echo -e "\n\nVersão ${ruby_version} do ruby já instalada."
fi

echo -e "\n\nSetando ruby ${ruby_version}"
rvm use ${ruby_version}

echo -e "\n\nCriando gemset '${gemset_name}' para o ruby ${ruby_version}"
rvm --create ${ruby_version}@${gemset_name}

# verificar se o rails ja se encontra instalado
is_rails_install=$(rails -v 2> /dev/null | grep ${rails_version} > /dev/null; echo $?)

if [ ${is_rails_install} -gt 0 ]; then
  echo -e "\n\nInstalando o rails ${rails_version}"
  gem install rails -v ${rails_version} --no-rdoc --no-ri
else
  echo -e "\n\nrails ${rails_version} já instalada"
fi

# configurando conta do git
echo -e "\n\nDeseja configurar a sincronia deste computador com o Github? y/N"
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
