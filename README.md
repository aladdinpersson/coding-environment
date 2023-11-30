# Coding Environment Setup

This guide assumes you are setting up the environment on a Linux system.

## Neovim Setup

1. **Run the Initial Setup Script:**

   Start by executing the `linux.sh` script. This script should handle the installation of Neovim and other necessary packages.

   ```sh
   ./linux.sh
   ```

   If on mac:
   ```sh
   ./mac.sh
   ```

2. **Install Neovim Plugins:**

   Open a file with Neovim to trigger the installation of plugins using Packer.

   ```sh
   nvim somefile
   ```

   Inside Neovim, initiate the plugin installation:

   ```vim
   :PackerSync
   ```

   Wait for the plugin synchronization to complete before proceeding.

## Tmux Configuration

1. **Reload tmux Configuration:**

   Start or attach to a tmux session:

   ```sh
   tmux
   ```

   Inside the tmux session, reload the configuration file:

   ```tmux
   Ctrl+a :source ~/.tmux.conf
   ```

2. **Install tmux Plugins:**

   Still within the tmux session, install the plugins:

   ```tmux
   Ctrl+a I
   ```

   This will fetch and install the plugins listed in your `.tmux.conf`.

After completing these steps, your coding environment with Neovim and tmux should be ready to use. Make sure to customize your `linux.sh`, `.tmux.conf`, and Neovim configuration files to suit your preferences.
```

Then we need to setup:
:Github Copilot
