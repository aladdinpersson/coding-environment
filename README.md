# Coding Environment Setup

This guide will help you set up a coding environment on both Linux and macOS systems.

## Initial Setup

1. **Run the Setup Script:**

   For Linux, execute the `linux.sh` script:

   ```sh
   ./linux.sh
   ```

   For macOS, execute the `mac.sh` script:

   ```sh
   ./mac.sh
   ```

   These scripts will install Neovim, tmux, and other necessary packages.

## Neovim Configuration

1. **Install Neovim Plugins:**

   Trigger the installation of Neovim plugins by opening Neovim:

   ```sh
   nvim somefile
   ```

   Within Neovim, run the following command to synchronize the plugins:

   ```vim
   :PackerSync
   ```

   Wait for the process to complete before exiting Neovim.

## Tmux Configuration

1. **Reload tmux Configuration:**

   Start or attach to a tmux session:

   ```sh
   tmux
   ```

   Inside the tmux session, reload the configuration:

   ```tmux
   Ctrl+b :source ~/.tmux.conf
   ```

   (Note: The default prefix key in tmux is `Ctrl+b`, unless you have customized it to `Ctrl+a` or another combination.)

2. **Install tmux Plugins:**

   Install the plugins specified in `.tmux.conf`:

   ```tmux
   Ctrl+b I
   ```

   This command will download and apply the tmux plugins.

## GitHub Copilot Setup

1. **Authenticate GitHub Copilot CLI:**

   Run the following command to authenticate the GitHub Copilot CLI:

   ```sh
   github-copilot-cli auth
   ```

   Follow the prompts to complete the authentication process.

2. **Configure GitHub Copilot in Zsh:**

   Add the GitHub Copilot CLI alias to your `.zshrc` and source it:

   ```sh
   echo 'eval "$(github-copilot-cli alias -- "$0")"' >> ~/.zshrc && source ~/.zshrc
   ```

After completing these steps, your coding environment, including Neovim, tmux, and GitHub Copilot, should be fully configured and ready for use. Customize your `linux.sh` or `mac.sh`, `.tmux.conf`, and Neovim configuration files as needed to tailor the environment to your preferences.