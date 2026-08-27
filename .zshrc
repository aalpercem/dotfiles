autoload -Uz colors && colors
setopt PROMPT_SUBST

export EDITOR="nvim"

# Load aliases
[ -r "$HOME/.aliases" ] && [ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
unset file

# zsh-autosuggestions (brew)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (brew)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship Setup
eval "$(starship init zsh)"
