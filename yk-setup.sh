# nuke existing profile
rm -rf ~/.gnupg 

# Getting settings
curl -o ~/.gnupg/gpg.conf https://raw.githubusercontent.com/drduh/config/master/gpg.conf

# Permissions
chmod 600 ~/.gnupg/gpg.conf

# Import Key
gpg --import $PUBLIC_KEY

# Trust new key
gpg --edit-key $KEYID