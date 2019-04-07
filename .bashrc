# eval `ssh-agent -s`

eval $( gpg-agent --daemon --enable-ssh-support )

[ -n "$PS1" ] && source ~/.bash_profile;
