#! /bin/bash

# My prefered font
sudo apt install -y fonts-firacode

sudo apt-get -y update
sudo apt-get -y install zsh
sudo apt-get -y install curl
sudo apt-get -y install fzf
sudo apt-get -y install bat
sudo apt-get -y install fd-find

CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cd
ln -s -f .dotfiles/zsh/zshrc .zshrc
mv .oh-my-zsh .dotfiles/zsh/
cd ~/.dotfiles/zsh/.oh-my-zsh/plugins
git clone git@github.com:zsh-users/zsh-autosuggestions
git clone git@github.com:zsh-users/zsh-syntax-highlighting
cd ~/.dotfiles/zsh/
cp myagnoster.zsh-theme ~/.dotfiles/zsh/.oh-my-zsh/themes/
chsh -s `which zsh`
