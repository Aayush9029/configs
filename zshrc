# Powerlevel10k Configuration
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Key Bindings
bindkey '^[[Z' reverse-menu-complete
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# Completion Configuration
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' rehash true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;34'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion::complete:*' use-cache true

# Auto Suggestions
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
set ZSH_AUTOSUGGEST_USE_ASYNC=true

# Fast Syntax Highlighting
source ~/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Aliases
alias lg="lazygit"
alias ":wq"="exit"
alias "??"="ghcs"
alias bubu="brew update; brew upgrade; brew cleanup; brew doctor"

# Environment Variables
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="~/Documents/bin:$PATH"

# Bun Completions
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

# Function Definitions
zshare() {
    local port=${1:-8000}
    echo "🌍 Starting share on port $port..."
    local temp_file=$(mktemp)
    zrok share public localhost:$port --headless > "$temp_file" 2>&1 &
    local pid=$!
    local count=0
    while [ $count -lt 10 ]; do
        local url=$(grep -o 'https://[^ ]*\.zrok\.io' "$temp_file")
        if [ -n "$url" ]; then
            echo "✨ Share created successfully!"
            echo "🔗 URL: $url"
            echo "$url" | pbcopy
            echo "📋 URL copied to clipboard"
            echo "💡 Share running in background (PID: $pid)"
            rm "$temp_file"
            return 0
        fi
        sleep 1
        count=$((count + 1))
    done
    echo "❌ Timed out waiting for share URL. Check output:"
    cat "$temp_file"
    rm "$temp_file"
    kill $pid 2>/dev/null
    return 1
}

zkill() {
    local port=${1:-8000}
    echo "🔍 Finding zrok process for port $port..."
    local pid=$(ps aux | grep "zrok share.*:$port" | grep -v grep | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "🎯 Found zrok process: $pid"
        kill $pid
        echo "✨ Killed zrok share on port $port"
    else
        echo "❌ No zrok share found on port $port"
        return 1
    fi
}

function context_gen {
    find . -name "*.$1" -type f -exec printf '\n=== %s ===\n' {} \; -exec cat {} \;
}
