
# Plugins
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Remove syntax underlining
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

alias lss='exa --long --git --group-directories-first --icons --color=always --time-style=default --no-permissions --no-user --grid'
autoload -Uz compinit && compinit

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

source ~/.nvm/nvm.sh

eval "$(starship init zsh)"
alias python=/usr/bin/python3

export PATH="$(brew --prefix)/opt/python@3/libexec/bin:$PATH"
