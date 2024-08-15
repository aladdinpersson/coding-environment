#!/usr/bin/env zsh

set -e  # Exit immediately if a command exits with a non-zero status.

# Update Homebrew and upgrade any already-installed formulae.
update_and_upgrade() {
    echo "Updating Homebrew..."
    brew update
    echo "Upgrading installed packages..."
    brew upgrade
    echo "Installing cmake..." 
    brew install cmake
}

# Install zsh if not already installed
install_zsh() {
    if ! command -v zsh &> /dev/null; then
        echo "Installing Zsh..."
        brew install zsh
    else
        echo "Zsh is already installed."
    fi
    
    local brew_zsh=$(brew --prefix)/bin/zsh
    if ! grep -Fxq "$brew_zsh" /etc/shells; then
        echo "Adding Homebrew Zsh to /etc/shells..."
        echo "$brew_zsh" | sudo tee -a /etc/shells
    fi

    if [[ $SHELL != $brew_zsh ]]; then
        echo "Changing default shell to Homebrew Zsh..."
        chsh -s "$brew_zsh"
    else
        echo "Homebrew Zsh is already the default shell."
    fi
}

# Install oh-my-zsh
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
        local MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
        local MINICONDA_SCRIPT="Miniconda3-latest-MacOSX-arm64.sh"
        
        curl -LO $MINICONDA_URL
        bash $MINICONDA_SCRIPT -b -p $HOME/miniconda3
        $HOME/miniconda3/bin/conda init zsh
        rm $MINICONDA_SCRIPT
    else
        echo "Miniconda is already installed."
    fi
}

# Install Node.js and npm using Homebrew
install_latest_nodejs_and_npm() {
    if ! command -v node &> /dev/null; then
        echo "Installing Node.js and npm..."
        brew install node
    else
        echo "Node.js is already installed. Updating..."
        brew upgrade node
    fi
    npm install -g npm@latest

    echo "Node.js $(node --version) and npm $(npm --version) have been installed/updated successfully."
}

# Install TMUX
install_tmux() {
    if ! command -v tmux &> /dev/null; then
        echo "Installing Tmux..."
        brew install tmux
    else
        echo "Tmux is already installed."
    fi
}

# Install Neovim
install_neovim() {
    if ! command -v nvim &> /dev/null; then
        echo "Installing Neovim..."
        brew install neovim
    else
        echo "Neovim is already installed."
    fi
}

# Create symbolic links
create_symbolic_links() {
    echo "Creating symbolic links..."
    DIR="$( cd "$( dirname "${(%):-%N}" )" &> /dev/null && pwd )"

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

# Clone the zsh-syntax-highlighting plugin
install_zsh_syntax_highlighting() {
    local DEST=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    if [[ ! -d $DEST ]]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $DEST
    else
        echo "zsh-syntax-highlighting is already installed."
    fi
}

# Install zsh-autosuggestions
install_zsh_autosuggestions() {
    local DEST=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    if [[ ! -d $DEST ]]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions $DEST
    else
        echo "zsh-autosuggestions is already installed."
    fi
}

# Install powerlevel10k theme
install_powerlevel10k() {
    local DEST=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    if [[ ! -d $DEST ]]; then
        echo "Installing powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $DEST
    else
        echo "powerlevel10k is already installed."
    fi
}

# Install Tmux Plugin Manager
install_tpm() {
    local DEST=$HOME/.tmux/plugins/tpm
    if [[ ! -d $DEST ]]; then
        echo "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm $DEST
    else
        echo "Tmux Plugin Manager is already installed."
    fi
}

# Source the new zsh configuration
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

# Install GitHub Copilot to Neovim
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

# Install GitHub Copilot CLI
install_copilot_cli() {
    if command -v npm &> /dev/null; then
        echo "Installing GitHub Copilot CLI..."
        npm install -g @githubnext/github-copilot-cli
    else
        echo "npm is not installed. Skipping GitHub Copilot CLI installation."
    fi
}

main() {
    # Check if Homebrew is installed, install if not
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for the current session
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    update_and_upgrade
    install_zsh
    install_oh_my_zsh
    install_powerlevel10k
    install_miniconda
    install_latest_nodejs_and_npm
    install_tmux
    install_neovim
    create_symbolic_links
    install_zsh_syntax_highlighting
    install_zsh_autosuggestions
    install_tpm
    install_github_copilot
    install_copilot_cli
    
    # These actions are performed last to avoid interrupting the script
    source_zsh_config
    reload_tmux_config

    echo "Setup complete! Please restart your terminal for all changes to take effect."
}

main
