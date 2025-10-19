# ~/.bashrc

# shellcheck disable=SC1091
# shellcheck disable=SC2034
# shellcheck disable=SC2148

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# could also be at /etc/bashrc
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# https://stackoverflow.com/a/791800
stty -ixon

EDITOR='code --wait'

alias cat='bat'
alias gdown='pipx run gdown'
alias gpustat='gpustat -cp --watch'
alias gputop='nvitop'
alias grep='grep --color=auto'
alias jerma='sudo systemctl start actions.runner.JermaSites-Jerma-Subtitle-Search.marvin.service && gh workflow run 139208317 --repo JermaSites/Jerma-Subtitle-Search'
alias kys='shutdown -h now'
alias ls='ls --color=auto'
alias neofetch='fastfetch'
alias pipes='pipes-rs'
alias psoff='dualsensectl lightbar off && dualsensectl microphone-led off && dualsensectl player-leds off'
alias sleepo='systemctl suspend'
alias sudo='doas'
alias wtf='wtf -o'
alias yeet='paru -Rcs'
alias pip='uv pip'
alias pvenv='uv venv && source .venv/bin/activate'

[[ $TERM = 'xterm-kitty' ]] && alias ssh='kitten ssh'

function bd {
    if betterdiscordctl -i traditional install &> /dev/null || betterdiscordctl -i flatpak install &> /dev/null; then
        echo "BetterDiscord installed successfully."
    else
        echo "BetterDiscord installation failed."
    fi
}

function sidestore {
    local email
    local pass
    read -rp 'Apple ID email: ' email
    read -rp 'Apple ID password: ' pass
    curl -fsSL -o ~/Downloads/SideStore.ipa https://github.com/SideStore/SideStore/releases/latest/download/SideStore.ipa
    # https://github.com/NyaMisty/AltServer-Linux/issues/99#issuecomment-1616730147
    curl -fsSL -o ~/Downloads/anisette-server https://github.com/Dadoum/Provision/releases/download/2.1.0/anisette-server-x86_64
    chmod +x ~/Downloads/anisette-server
    ~/Downloads/anisette-server &
    altserver -a "$email" -p "$pass" -u "$(lsusb -s "$(lsusb | grep "Apple" | cut -d ' ' -f 2):$(lsusb | grep "Apple" | cut -d ' ' -f 4 | sed 's/://')" -v | grep iSerial | awk '{print $3}' | sed 's/^\(........\)/\1-/')" ~/Downloads/SideStore.ipa
}

bind 'set completion-ignore-case on'
bind 'set enable-bracketed-paste off'
bind "set bell-style none"

eval "$(beet completion)"
eval "$(oh-my-posh init bash)"
eval "$(register-python-argcomplete --shell bash pipx)"
eval "$(starship init bash)"
eval "$(syncthing install-completions)"
eval "$(thefuck --alias)"
eval "$(uv generate-shell-completion bash)"
eval "$(uvx --generate-shell-completion bash)"

export PATH="$HOME/.cargo/bin:$PATH" # rust
export PATH="$HOME/.local/bin:$PATH" # pipx
export DOTNET_CLI_TELEMETRY_OPTOUT=1
