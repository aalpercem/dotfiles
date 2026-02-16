#!/usr/bin/env zsh
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# And also installs MacOS Software
# And also installs Homebrew Packages and Casks (Apps)
############################

set -euo pipefail

# dotfiles directory
dotfiledir="${HOME}/dotfiles"

# list of files/folders to symlink in ${homedir}
files=(zshrc zprofile zprompt bashrc bash_profile bash_prompt aliases private)

# XDG config directories to symlink from ~/dotfiles/.config
config_dirs=(wezterm opencode nvim)

# change to the dotfiles directory
echo "Changing to the ${dotfiledir} directory"
cd "${dotfiledir}" || exit

# create symlinks (will overwrite old dotfiles)
for file in "${files[@]}"; do
    echo "Creating symlink to $file in home directory."
    ln -sf "${dotfiledir}/.${file}" "${HOME}/.${file}"
done

echo "Creating symlink to aerospace.toml in home directory."
ln -sf "${dotfiledir}/.aerospace.toml" "${HOME}/.aerospace.toml"

echo "Ensuring ~/.config exists"
mkdir -p "${HOME}/.config"

for dir in "${config_dirs[@]}"; do
    echo "Creating symlink to ${dir} in ~/.config"
    ln -sfn "${dotfiledir}/.config/${dir}" "${HOME}/.config/${dir}"
done

# Run the MacOS Script
./macOS.sh

# Run the Homebrew Script
./brew.sh

echo "Installation complete."
echo "Post-install checklist: ${dotfiledir}/POST_INSTALL_CHECKLIST.md"
