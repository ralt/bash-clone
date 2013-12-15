#!/bin/bash

apt-get update
apt-get install sbcl postgresql --yes
mkdir -p ~/quicklisp/local-projects
ln -sfn /vagrant/ ~/quicklisp/local-projects/bash-clone
wget http://beta.quicklisp.org/quicklisp.lisp
echo 'sbcl--load quicklisp.lisp --eval "(quicklisp-quickstart:install)" --eval "(ql:add-to-init-file)" --eval "(quit)"' > postinstall.sh
chmod +x postinstall.sh
echo "Don't forget to run ./postinstall.sh!"
