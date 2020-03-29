#!/bin/bash

# this install and configures git-secrets in a nice way.
# https://github.com/awslabs/git-secrets/blob/master/README.rst

# requires brew
if [ ! -x "$(command -v git-secrets)" ]; then
	echo 'installing git-secrets...'
	brew install git-secrets
	echo "done! $(tput setaf 2)✓$(tput sgr 0)"
fi

# update repo
echo -n 'updating the repo...'
git pull origin master
echo "done! $(tput setaf 2)✓$(tput sgr 0)"

# add hooks to everything in the future
echo -n 'setting up global config...'
git secrets --install ~/.git-templates/git-secrets 2>/dev/null
git secrets --register-aws --global 2>/dev/null
git config --global init.templateDir ~/.git-templates/git-secrets 2>/dev/null
echo "done! $(tput setaf 2)✓$(tput sgr 0)"

# patterns we want to avoid
echo -n 'adding default pattern matching for passwords...'
git secrets --add '.*[pP][aA][sS][sS][wW][oO][rR][dD]\s*[:=]\s*.+' --global
git secrets --add '.*[sS][eE][cC][rR][eE][tT]\s*[:=]\s*.+' --global
git secrets --add '.*[aA][uU][tT][hH][oO][rR][iI][zZ][aA][tT][iI][oO][nN]\s*[:=]\s*.+' --global
git secrets --add '.*[tT][oO][kK][eE][nN]\s*[:=]\s*.+' --global
git secrets --add --allowed '/*/*/*REMOVED/*/*/*' --global
git secrets --add --allowed --literal '1234567890' --global
git secrets --add --allowed --literal '0987654321' --global
git secrets --add --allowed --literal 'docker_password' --global
git secrets --add --allowed --literal 'cassandra' --global
git secrets --add --allowed --literal 'gopass' --global
git secrets --add --allowed --literal "''" --global
echo "done! $(tput setaf 2)✓$(tput sgr 0)"

# auto-find all git remp
echo -n 'installing git-secrets to all local git repositories...'
if [ ! -d "temp" ]; then
	mkdir temp
fi
find . -name ".git" -print > temp/current.txt
chmod +x temp/current.txt

cat temp/current.txt | while read directory; do
  cd $directory 2>/dev/null
  git secrets --install 2>/dev/null
done

rm -rf temp

echo "done! $(tput setaf 2)✓$(tput sgr 0)"
echo
echo "Thanks for using Hatz's git-secret installer. From now on there will be a warning when you try to commit a password."
echo
echo "Always consider where passwords should be stored."
echo
echo "Please reload bash by closing your terminal or sourcing your bash profile for changes to take effect."
