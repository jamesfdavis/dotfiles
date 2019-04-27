# ~/.gnupg profiles get mapped to yk hardware devices.

# nuke existing profile

rm -rf ~/.gnupg 

# Getting settings
curl -o ~/.gnupg/gpg.conf https://raw.githubusercontent.com/drduh/config/master/gpg.conf

