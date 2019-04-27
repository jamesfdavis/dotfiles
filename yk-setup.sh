# nuke existing profile
rm -rf ~/.gnupg 

mkdir ~/.gnupg

# Getting settings
curl -o ~/.gnupg/gpg.conf https://raw.githubusercontent.com/drduh/config/master/gpg.conf

# Import Key
gpg --import $PUBLIC_KEY

# Trust new key
gpg --edit-key $KEYID