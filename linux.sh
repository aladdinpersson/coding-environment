#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Check for sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo privileges" 
   exit 1
fi

update_and_upgrade() {
    echo "Updating package lists..."
    apt-get update -y
    echo "Upgrading installed packages..."
    apt-get upgrade -y
    echo "Installing cmake..." 
    apt-get install build-essential cmake -y
}

install_zsh() {
    if ! command -v zsh &> /dev/null; then
        echo "Installing Zsh..."
        apt-get install -y zsh
        chsh -s $(which zsh)
    else
        echo "Zsh is already installed."
    fi
}

install_oh_my_zsh() {
    if [[ ! -d $HOME/.oh-my-zsh ]]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh is already installed."
    fi
}

install_miniconda() {
    if [[ ! -d $HOME/miniconda3 ]]; then
        echo "Installing Miniconda..."
        local MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
        local MINICONDA_SCRIPT="Miniconda3-latest-Linux-x86_64.sh"
        
        curl -LO $MINICONDA_URL
        bash $MINICONDA_SCRIPT -b -p $HOME/miniconda3
        $HOME/miniconda3/bin/conda init bash
        $HOME/miniconda3/bin/conda init zsh
        rm $MINICONDA_SCRIPT
    else
        echo "Miniconda is already installed."
    fi
}

install_latest_nodejs_and_npm() {
    if ! command -v node &> /dev/null; then
        NODE_MAJOR=20  # Replace with desired version (e.g., 16, 18, 20, 21)

        apt-get update && apt-get install -y ca-certificates curl gnupg

        mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

        apt-get update && apt-get install -y nodejs
    else
        echo "Node.js is already installed. Updating..."
        npm install -g npm@latest
    fi

    echo "Node.js $(node --version) and npm $(npm --version) have been installed/updated successfully."
}

install_tmux() {
    if ! command -v tmux &> /dev/null; then
        echo "Installing Tmux..."
        apt-get install -y tmux
    else
        echo "Tmux is already installed."
    fi
}

install_neovim() {
    if ! command -v nvim &> /dev/null; then
        echo "Installing Neovim..."
        add-apt-repository -y ppa:neovim-ppa/unstable
        apt-get update
        apt-get install -y neovim
    else
        echo "Neovim is already installed."
    fi
}

create_symbolic_links() {
    echo "Creating symbolic links..."
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.config/nvim/undodir"  # Ensure the undo directory exists

    local links=(
        ".zshrc"
        ".tmux.conf"
        ".p10k.zsh"
    )

    for link in "${links[@]}"; do
        if [[ -f "$DIR/$link" ]]; then
            ln -sfn "$DIR/$link" "$HOME/$link"
        else
            echo "Warning: $DIR/$link does not exist. Skipping..."
        fi
    done

    if [[ -d "$DIR/nvim" ]]; then
        ln -sfn "$DIR/nvim" "$HOME/.config/nvim"
    else
        echo "Warning: $DIR/nvim directory does not exist. Skipping..."
    fi
}

install_zsh_syntax_highlighting() {
    local DEST=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    if [[ ! -d $DEST ]]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $DEST
    else
        echo "zsh-syntax-highlighting is already installed."
    fi
}

install_zsh_autosuggestions() {
    local DEST=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    if [[ ! -d $DEST ]]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions $DEST
    else
        echo "zsh-autosuggestions is already installed."
    fi
}

install_powerlevel10k() {
    local DEST=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    if [[ ! -d $DEST ]]; then
        echo "Installing powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $DEST
    else
        echo "powerlevel10k is already installed."
    fi
}

install_tpm() {
    local DEST=$HOME/.tmux/plugins/tpm
    if [[ ! -d $DEST ]]; then
        echo "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm $DEST
    else
        echo "Tmux Plugin Manager is already installed."
    fi
}

source_zsh_config() {
    echo "Sourcing new Zsh configuration..."
    source $HOME/.zshrc
}

reload_tmux_config() {
    if command -v tmux &> /dev/null; then
        echo "Reloading Tmux configuration..."
        if tmux list-sessions &> /dev/null; then
            tmux source $HOME/.tmux.conf
        else
            echo "No active Tmux sessions. Configuration will be loaded on next Tmux start."
        fi
    else
        echo "Tmux is not installed. Skipping configuration reload."
    fi
}

install_github_copilot() {
    if command -v nvim &> /dev/null; then
        local COPILOT_DIR="$HOME/.config/nvim/pack/github/start/copilot.vim"
        if [[ ! -d $COPILOT_DIR ]]; then
            echo "Installing GitHub Copilot for Neovim..."
            mkdir -p $HOME/.config/nvim/pack/github/start
            git clone https://github.com/github/copilot.vim.git $COPILOT_DIR
        else
            echo "GitHub Copilot for Neovim is already installed."
        fi
    else
        echo "Neovim is not installed. Skipping GitHub Copilot installation."
    fi
}

install_copilot_cli() {
    if command -v npm &> /dev/null; then
        echo "Installing GitHub Copilot CLI..."
        npm install -g @githubnext/github-copilot-cli
    else
        echo "npm is not installed. Skipping GitHub Copilot CLI installation."
    fi
}

main() {
    update_and_upgrade
    install_zsh
    install_oh_my_zsh
    install_miniconda
    install_latest_nodejs_and_npm
    install_tmux
    install_neovim
    create_symbolic_links
    install_zsh_syntax_highlighting
    install_zsh_autosuggestions
    install_powerlevel10k
    install_tpm
    install_github_copilot
    install_copilot_cli
    
    # These actions are performed last to avoid interrupting the script
    source_zsh_config
    reload_tmux_config

    echo "Setup complete! Please restart your terminal for all changes to take effect."
}

main
