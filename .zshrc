autoload -Uz colors && colors
setopt PROMPT_SUBST

# Load dotfiles:
# for file in ~/.{zprompt,aliases,private}; do
#    [ -r "$file" ] && [ -f "$file" ] && source "$file"
#done
unset file

. "$HOME/.local/bin/env"

# Added by Antigravity
export PATH="/Users/cemozturk/.antigravity/antigravity/bin:$PATH"

# zsh-autosuggestions (brew)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (brew)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/cemozturk/.lmstudio/bin"
# End of LM Studio CLI section

# Starship Setup
eval "$(starship init zsh)"
