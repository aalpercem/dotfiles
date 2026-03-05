# Load .bashrc if available
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Set PATHS
if [ -x "/opt/homebrew/bin/brew" ]; then
    # For Apple Silicon Macs
    export PATH="/opt/homebrew/bin:$PATH"
fi

. "$HOME/.local/bin/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/cemozturk/.lmstudio/bin"
# End of LM Studio CLI section

