# nuke existing profile
rm -rf ~/.gnupg 

# Init folders
gpg --list-keys

# Getting settings
curl -o ~/.gnupg/gpg.conf https://raw.githubusercontent.com/drduh/config/master/gpg.conf

# Import public key
gpg --import $PUBLIC_KEY

# Trust public key
gpg --edit-key $KEYID

echo "Restart terminal session."