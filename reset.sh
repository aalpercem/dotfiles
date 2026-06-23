#!/usr/bin/env zsh
#
# reset.sh — remove everything install.sh set up
# Run from the dotfiles directory: ./reset.sh
#
set -uo pipefail

DOTFILEDIR="${HOME}/dotfiles"

info()  { printf "\033[0;32m%s\033[0m %s\n" "[INFO]" "$1"; }
warn()  { printf "\033[1;33m%s\033[0m %s\n" "[WARN]" "$1"; }
error() { printf "\033[0;31m%s\033[0m %s\n" "[ERROR]" "$1"; }

# ── Banner & Confirmation ──
cat <<'EOF'

 ╔═══════════════════════════════════════════════╗
 ║  Dotfiles Reset Script                       ║
 ║  Removes everything install.sh set up.       ║
 ╚═══════════════════════════════════════════════╝

  • Dotfile symlinks (~/.zshrc, ~/.config/nvim, …)
  • macOS system preferences (Dock, Finder, scroll, …)
  • Desktop wallpaper → macOS default
  • Homebrew packages, casks, taps from the repo list
  • Dock persistent apps
  • Homebrew zsh → macOS default shell
  • ~/Desktop/Screenshots directory

EOF

echo -n "Continue? (y/N) "
read -r reply
if [[ ! "$reply" =~ ^[Yy]$ ]]; then
    info "Aborted."
    exit 0
fi

# ── Sudo upfront — refresh every 60s ──
info "Some operations need sudo. Enter your password if prompted."
sudo -v || { error "sudo not available. Exiting."; exit 1; }
while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done &

# ═══════════════════════════════════════════════════════
#  1.  REMOVE SYMLINKS
# ═══════════════════════════════════════════════════════
printf "\n%s\n" "────────────────────────────────────────"
info "Removing symlinks…"

files=(zshrc zprofile zprompt bashrc bash_profile bash_prompt aliases private)
for file in "${files[@]}"; do
    rm -f "${HOME}/.${file}" 2>/dev/null || true
done

rm -f "${HOME}/.aerospace.toml" 2>/dev/null || true

config_dirs=(wezterm opencode nvim karabiner sketchybar)
for dir in "${config_dirs[@]}"; do
    target="${HOME}/.config/${dir}"
    [ -L "$target" ] && rm -f "$target" 2>/dev/null || true
done

info "Symlinks removed."

# ═══════════════════════════════════════════════════════
#  2.  RESET macOS DEFAULTS
# ═══════════════════════════════════════════════════════
printf "\n%s\n" "────────────────────────────────────────"
info "Resetting macOS defaults…"

defaults delete com.apple.dock orientation             2>/dev/null || true
defaults delete com.apple.dock tilesize                2>/dev/null || true
defaults delete com.apple.dock show-recents            2>/dev/null || true
defaults delete com.apple.dock autohide-delay          2>/dev/null || true
defaults delete com.apple.dock autohide-time-modifier  2>/dev/null || true
defaults delete com.apple.dock expose-group-apps       2>/dev/null || true
defaults delete com.apple.dock persistent-apps         2>/dev/null || true

defaults delete com.apple.finder AppleShowAllFiles             2>/dev/null || true
defaults delete com.apple.finder FXPreferredViewStyle          2>/dev/null || true
defaults delete com.apple.finder ShowPathbar                   2>/dev/null || true
defaults delete com.apple.finder FXEnableExtensionChangeWarning 2>/dev/null || true
defaults delete NSGlobalDomain NSTableViewDefaultSizeMode       2>/dev/null || true

defaults delete NSGlobalDomain com.apple.swipescrolldirection 2>/dev/null || true
defaults delete NSGlobalDomain ApplePressAndHoldEnabled       2>/dev/null || true

defaults delete com.apple.screencapture location 2>/dev/null || true
defaults delete com.apple.controlcenter "NSStatusItem Visible Bluetooth" 2>/dev/null || true

killall Dock Finder SystemUIServer ControlCenter 2>/dev/null || true

info "macOS defaults reset."

# ═══════════════════════════════════════════════════════
#  3.  RESET WALLPAPER
# ═══════════════════════════════════════════════════════
printf "\n%s\n" "────────────────────────────────────────"
info "Resetting wallpaper to macOS default…"

{ osascript -e '
tell application "System Events"
    set desktopCount to count of desktops
    repeat with desktopNumber from 1 to desktopCount
        tell desktop desktopNumber
            set picture to "/System/Library/Desktop Pictures/Sonoma.heic"
        end tell
    end repeat
end tell
' 2>/dev/null; } || {
    # Fallback: try common wallpaper paths
    for f in \
        "/System/Library/Desktop Pictures/Sequoia.heic" \
        "/System/Library/Desktop Pictures/Sonoma.heic" \
        "/System/Library/Desktop Pictures/Ventura.heic" \
        "/System/Library/Desktop Pictures/Monterey.heic" \
        "/System/Library/Desktop Pictures/Big Sur.heic"; do
        [ -f "$f" ] && osascript -e "
            tell application \"System Events\"
                set desktopCount to count of desktops
                repeat with desktopNumber from 1 to desktopCount
                    tell desktop desktopNumber
                        set picture to \"$f\"
                    end tell
                end repeat
            end tell
        " 2>/dev/null && break
    done
} || warn "Could not reset wallpaper (permissions or file not found)."

info "Wallpaper reset."

export HOMEBREW_NO_REQUIRE_TAP_TRUST=1

# ═══════════════════════════════════════════════════════
#  4.  UNINSTALL HOMEBREW PACKAGES
# ═══════════════════════════════════════════════════════
printf "\n%s\n" "────────────────────────────────────────"
info "Removing Homebrew packages from repo list…"

packages=(
    "bash" "btop" "cloudflared" "coreutils" "curl" "docker" "docker-compose"
    "eza" "fastfetch" "ffmpeg" "git" "glow" "hf" "hunk" "immich-cli"
    "imagemagick" "jq" "kanata" "lazygit" "llmfit" "luarocks" "mactop"
    "make" "mdcat" "neovim" "nowplaying-cli" "opencode" "pipx" "poppler"
    "resvg" "sketchybar" "starship" "swiftformat" "swiftlint" "xcbeautify"
    "xcode-build-server" "xcp" "yazi" "zsh" "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)

count=0
for pkg in "${packages[@]}"; do
    if brew list --formula "$pkg" &>/dev/null; then
        echo "  Uninstalling $pkg…"
        brew uninstall "$pkg" &>/dev/null || warn "Could not uninstall $pkg (may be a dependency of other formulae)"
        ((count++))
    fi
done
[[ $count -eq 0 ]] && warn "No packages were installed or already removed."

# ═══════════════════════════════════════════════════════
#  5.  UNINSTALL HOMEBREW CASKS
# ═══════════════════════════════════════════════════════
printf "\n%s\n" "────────────────────────────────────────"
info "Removing Homebrew casks from repo list…"

apps=(
    "aerospace" "cloudflare-warp" "docker-desktop"
    "font-jetbrains-mono-nerd-font" "font-sketchybar-app-font" "github"
    "google-chrome" "karabiner-elements" "librewolf" "localsend" "obsidian"
    "raindropio" "raycast" "sf-symbols" "stats" "sublime-merge" "vlc" "wezterm"
)

count=0
for app in "${apps[@]}"; do
    if brew list --cask "$app" &>/dev/null; then
        echo "  Uninstalling $app…"
        brew uninstall --cask "$app" &>/dev/null || warn "Could not uninstall $app"
        ((count++))
    fi
done
[[ $count -eq 0 ]] && warn "No casks were installed or already removed."

# ═══════════════════════════════════════════════════════
#  6.  REMOVE HOMEBREW TAPS
# ═══════════════════════════════════════════════════════
printf "\n%s\n" "────────────────────────────────────────"
info "Removing Homebrew taps…"

for tap in \
    "anomalyco/tap" "nikitabobko/tap" "gromgit/brewtils" "arimxyer/tap" \
    "felixkratz/formulae" "jesseduffield/lazygit" "modem-dev/tap"; do
    brew untap "$tap" 2>/dev/null || true
done

info "Taps removed."

# ═══════════════════════════════════════════════════════
#  7.  RESET SHELL TO macOS DEFAULT
# ═══════════════════════════════════════════════════════
printf "\n%s\n" "────────────────────────────────────────"
info "Resetting shell to macOS default /bin/zsh…"

BREW_ZSH="$(brew --prefix)/bin/zsh"
CURRENT_SHELL=$(dscl . -read /Users/"$(whoami)" UserShell 2>/dev/null | awk '{print $2}')

if [ "$CURRENT_SHELL" = "$BREW_ZSH" ]; then
    if grep -Fxq "$BREW_ZSH" /etc/shells; then
        sudo sed -i '' "\|$BREW_ZSH|d" /etc/shells 2>/dev/null || warn "Could not remove from /etc/shells"
    fi
    chsh -s /bin/zsh 2>/dev/null || warn "Could not change shell to /bin/zsh"
    info "Shell reset to /bin/zsh (effective on next login)."
else
    info "Shell already set to $CURRENT_SHELL, not Homebrew zsh. Skipping."
fi

# ═══════════════════════════════════════════════════════
#  8.  REMOVE SCREENSHOT DIRECTORY
# ═══════════════════════════════════════════════════════
printf "\n%s\n" "────────────────────────────────────────"
rm -rf "${HOME}/Desktop/Screenshots" 2>/dev/null || true
info "~/Desktop/Screenshots removed (if empty)."

# ═══════════════════════════════════════════════════════
#  DONE
# ═══════════════════════════════════════════════════════
printf "\n%s\n" "═══════════════════════════════════════════"
info "Reset complete."
echo   "Some changes (Dock, shell) need a logout/restart to take effect."
printf "%s\n\n" "═══════════════════════════════════════════"
