# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey '^[[Z' reverse-menu-complete
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

## menu-style
zstyle ':completion:*' menu select
autoload -Uz compinit && compinit
zstyle ':completion:*' special-dirs true

# case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Tab completion colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# add new installed packages into completions
zstyle ':completion:*' rehash true

# Use better completion for the kill command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;34'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# use completion cache
zstyle ':completion::complete:*' use-cache true

#auto suggestions
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
set ZSH_AUTOSUGGEST_USE_ASYNC=true

#fast syntax highlighting
source ~/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# powerlevel10k
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# alias stuff
alias lg="lazygit"
alias ":wq"="exit"
# bun completions
[ -s "/Users/yush/.bun/_bun" ] && source "/Users/yush/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(gh copilot alias -- zsh)"

alias "??"="ghcs"
alias bubu="brew update; brew upgrade; brew cleanup; brew doctor"

export PATH="/Users/yush/Documents/bin:$PATH"

function context_gen {
    find . -name "*.$1" -type f -exec printf '\n=== %s ===\n' {} \; -exec cat {} \;
}
