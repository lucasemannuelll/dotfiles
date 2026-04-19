# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

PS1='\[\e[38;2;187;154;247m\][\[\e[38;2;125;207;255m\]\D{%a %b %d}\[\e[38;2;187;154;247m\]] \[\e[38;2;166;209;137m\]\h\[\e[38;2;86;95;137m\]:\[\e[38;2;125;207;255m\]\w\[\e[0m\] '

# Example aliases
alias bashrc="nvim ~/.bashrc"
alias mkdir='mkdir -p'
alias ..='cd ..'
alias ...='cd ../..'
alias cls='clear'
alias update='sudo dnf update -y'
alias cpy='xsel --clipboard'
alias switch='gh auth switch'
alias rename_script='python ~/rename_script.py'
alias fastfetch='fastfetch -c ~/.config/fastfetch/6.jsonc'
alias ls='ls --color --group-directories-first'
alias ll='ls -lh'
alias vim='nvim'
alias playmusic='mpv --shuffle --no-video --loop-playlist=inf "$HOME/Music/"'
alias config='/usr/bin/git --git-dir=$HOME/Repos/dotfiles/ --work-tree=$HOME'

export PATH=/home/lucas/.local/bin/:/usr/local/bin:/usr/bin:/usr/local/sbin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export FZF_DEFAULT_COMMAND='fd --exclude venv --exclude ventoy-1.1.07-linux --exclude __pycache__ --exclude .choosenim --exclude "GOG Games"'

eval "$(zoxide init bash)"
eval "$(zoxide init --cmd j bash)"

export EDITOR='nvim'
export VISUAL='nvim'

export MAN='nvim +Man'
