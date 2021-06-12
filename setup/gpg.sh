#!/bin/zsh

# https://github.com/drduh/YubiKey-Guide
# https://docs.github.com/en/github/authenticating-to-github/troubleshooting-ssh


wget -O $GNUPGHOME/gpg.conf https://raw.githubusercontent.com/drduh/config/master/gpg.conf
vim .gnupg/gpg.conf

gpg --expert --full-generate-key

gpg --expert --edit-key $KEYID
wget https://raw.githubusercontent.com/drduh/config/master/gpg-agent.conf


gpg --with-keygrip -k $KEYID
touch ~/.gnupg/sshcontrol