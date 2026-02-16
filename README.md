# Development Environment Setup

This repository contains scripts and configuration files to set up a development environment for macOS. It's tailored for software development, focusing on a clean, minimal, and efficient setup.

## Overview

An automated setup for a macOS development environment, including:
- Essential development tools and software
- Shell configurations (Bash & Zsh)
- Homebrew packages and cask applications 
- System preferences and defaults

This repository contains scripts and configurations to replicate my personal development environment. Follow the installation instructions below to set up your machine with the same tooling and preferences.

## Important Note Before Installation

⚠️**WARNING:** The configurations and scripts in this repository are `HIGHLY PERSONALIZED` to my own preferences and workflows. If you decide to use them, please be aware that they will `MODIFY` your current system, potentially making some changes that are `IRREVERSIBLE` without a fresh installation of your operating system.

Furthermore, while I strive to backup files wherever possible, I cannot guarantee that all files are backed up. The backup mechanism is designed to backup `SOME` files `ONCE`. If the script is run more than once, the initial backups will be `OVERWRITTEN`, potentially resulting in loss of data. While I could implement timestamped backups to preserve multiple versions, this setup is optimized for my personal use, and a single backup suffices for me.

If you would like a development environment similar to mine, I highly encourage you to fork this repository and make your own personalized changes to these scripts instead of running them exactly as I have them written for myself.

A less serious (but potentially annoying) change it will make is setting the Desktop background to the image I use in my tutorials. This is the script I use to set up machines I will be recording on, after all.

I likely won't accept pull requests unless they align closely with my personal preferences and the way I use my development environment. But if there are some obvious errors in my scripts then corrections would be welcome!

If you choose to run these scripts, please do so with `EXTREME CAUTION`. It's recommended to review the scripts and understand the changes they will make to your system before proceeding.

By using these scripts, you acknowledge and accept the risk of potential data loss or system alteration. Proceed at your own risk.

## Getting Started

### Prerequisites

-  macOS (The scripts are tailored for macOS)

### Installation

1. Clone the repository to your local machine:
   ```sh
   git clone https://github.com/aalpercem/dotfiles.git ~/dotfiles
   ```
2. Navigate to the `dotfiles` directory:
   ```sh
   cd ~/dotfiles
   ```
3. Run the installation script:
   ```sh
   ./install.sh
   ```

The installer runs in non-interactive mode.

This script will:

-  Create symlinks for dotfiles (`.bashrc`, `.zshrc`, etc.)
-  Run macOS-specific configurations
-  Install Homebrew packages and casks
-  Configure system preferences and defaults

After installation, complete the manual steps in `POST_INSTALL_CHECKLIST.md`.

## Configuration Files

-  `.bashrc` & `.zshrc`: Shell configuration files for Bash and Zsh.
-  `.shared_prompt`: Custom prompt setup used by both `.bash_prompt` & `.zprompt`
-  `.bash_prompt` & `.zprompt`: Custom prompt setup for Bash and Zsh.
-  `.bash_profile`: Setting system-wide environment variables
-  `.aliases`: Aliases for common commands. Some are personalized to my machines specifically (e.g. the 'yt' alias opening my YouTube Scripts')
-  `.private`: This is a file you'll create locally to hold private information and shouldn't be uploaded to version control
-  `settings/`: Directory containing general app configurations and settings.

### Customizing Your Setup

You're encouraged to modify the scripts and configuration files to suit your preferences. Here are some tips for customization based on the changes made in the project:

-  **Dotfiles**: Edit `.shared_prompt`, `.zprompt`, `.bash_prompt` to add or modify shell configurations.
- **Shell Scripts**: The `.sh` files in the project, such as `brew.sh` and `macOS.sh`, contain various customizations for setting up the development environment. You can modify these scripts to tailor the setup according to your preferences.
- **Settings Folder**: You can also add your own configuration files to the `settings/` directory to further customize your development environment.

## Contributing

Feel free to fork this repository and customize it for your setup. Pull requests for improvements and bug fixes are welcome, but as said above, I likely won't accept pull requests that simply add additional brew installations or change some settings unless they align with my personal preferences.

## License

This project is licensed under the MIT License - see the [LICENSE-MIT.txt](LICENSE-MIT.txt) file for details.

## Acknowledgments

Originally forked from [CoreyMSchafer's dotfiles](https://github.com/CoreyMSchafer/dotfiles), which was itself forked from [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)

-  Thanks to all the open-source projects used in this setup.
