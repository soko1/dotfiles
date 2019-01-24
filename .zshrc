transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }


# running in tmux always
if which tmux 2>&1 >/dev/null; then
  if [ $TERM != "screen-256color" ] && [  $TERM != "screen" ]; then
    tmux attach -t main || tmux new -s main; exit
  fi
fi

#SSH_ENV="$HOME/.ssh/environment"
eval `dircolors ~/.dircolors.256dark`

# Path to your oh-my-zsh installation.
export ZSH=$HOME/git/oh-my-zsh
export SSH_ASKPASS=/usr/bin/ssh-askpass
export EDITOR="vim"
export PAGER="most"
export PATH="$PATH:$HOME/.bin:/.local/bin"

alias y='~/.local/bin/youtube-dl -c -i -x --audio-format mp3 --yes-playlist $1'
alias pipupgradeall='pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install --user -U'
alias flatpak='flatpak --user '
alias scanlocal='sudo nmap -sP 192.168.88.1-254'
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'
alias fd_room="ssh -L 5001:localhost:5001 myroom"
alias fd_kb="torify ssh -L 9876:localhost:9876 kb "
alias mutt='LANG=ru_RU.UTF-8 mutt'
alias t='cd `mktemp -d`'
alias wsend='$HOME/.wsend/wsend'
alias wsend-gpg='$HOME/.wsend/wsend-gpg'
alias wget-gpg='$HOME/.wsend/wget-gpg'
#alias i="sudo apt-get install"
#alias u="sudo apt-get update && sudo apt-get upgrade -y"
alias i="sudo dnf install"
alias u="sudo dnf update -y"
alias pwgen="pwgen 25"
alias -g Il="|less"
alias backup_open='sudo cryptsetup luksOpen /dev/mapper/MyBackup-backup backup; sudo mount /dev/mapper/backup /mnt/backup'
alias backup_close='sudo umount /mnt/backup; sync;sync;sync;sudo cryptsetup luksClose /dev/mapper/backup'
alias tmux='tmux attach || ssh-agent tmux new'
alias maxfile='ls -lSrh'
alias maxdir='du -sh * | sort -h'
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias du='du -h'
alias umount='sudo umount'
alias reboot='sudo reboot'
#emacs
alias e='emacsclient -t'
alias ec='emacsclient -c'
#

ZSH_THEME="tjkirch"
DISABLE_AUTO_UPDATE="true"

plugins=(git autojump tmux pass colorize cp)

source $ZSH/oh-my-zsh.sh

