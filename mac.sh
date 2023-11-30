#!/bin/zsh

# Update Homebrew and upgrade any already-installed formulae.
update_and_upgrade() {
    echo "Updating Homebrew..."
    brew update
    echo "Upgrading installed packages..."
    brew upgrade
    echo "Installing cmake..." 
    brew install cmake
}

# Install zsh and make it your main shell
install_zsh() {
    brew install zsh
    chsh -s $(which zsh)
}

# Install oh-my-zsh
install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Install Miniconda
install_miniconda() {
    local MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
    local MINICONDA_SCRIPT="Miniconda3-latest-MacOSX-x86_64.sh"
    
    # Download Miniconda installation script
    curl -LO $MINICONDA_URL

    # Run the Miniconda installation script
    bash $MINICONDA_SCRIPT -b -p $HOME/miniconda3

    # Initialize Miniconda for Zsh
    $HOME/miniconda3/bin/conda init zsh

    # Remove the installation script
    rm $MINICONDA_SCRIPT
}

# Install Node.js and npm using Homebrew
install_latest_nodejs_and_npm() {
    brew install node
    npm install -g npm@latest

    # Verify the installation
    echo "Node.js $(node --version) and npm $(npm --version) have been installed successfully."
}

# Install TMUX
install_tmux() {
    brew install tmux
}

# Install Neovim
install_neovim() {
    brew install neovim
}

# Create symbolic links
create_symbolic_links() {
    # Get the directory of the current script
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

    # Ensure the .config directory exists
    if [ ! -d "$HOME/.config" ]; then
        mkdir -p "$HOME/.config"
    fi

    # Create symbolic links with proper quoting and the -n flag on ln
    ln -sfn "$DIR/.zshrc" "$HOME/.zshrc"
    ln -sfn "$DIR/.tmux.conf" "$HOME/.tmux.conf"
    ln -sfn "$DIR/nvim" "$HOME/.config/nvim"
    ln -sfn "$DIR/.p10k.zsh" "$HOME/.p10k.zsh"
}

# Clone the zsh-syntax-highlighting plugin
install_zsh_syntax_highlighting() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

# Install zsh-autosuggestions
install_zsh_autosuggestions() {
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

# Install powerlevel10k theme
install_powerlevel10k() {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
}

# Install Tmux Plugin Manager
install_tpm() {
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

# Source the new zsh configuration
source_zsh_config() {
    source ~/.zshrc
}

reload_tmux_config() {
    if tmux list-sessions &> /dev/null; then
        tmux source ~/.tmux.conf
    else
        echo "tmux server not running. Starting a new one and reloading configuration."
        tmux new-session -d
        tmux source ~/.tmux.conf
    fi
}

# Install GitHub Copilot to Neovim
install_github_copilot() {
    local COPILOT_DIR="$HOME/.config/nvim/pack/github/start/copilot.vim"
    if [[ ! -d $COPILOT_DIR ]]; then
        mkdir -p $HOME/.config/nvim/pack/github/start
        git clone https://github.com/github/copilot.vim.git $COPILOT_DIR
    else
        echo "Github Copilot directory already exists. Skipping clone."
    fi
}

# Install GitHub Copilot CLI
install_copilot_cli() {
    echo "Installing GitHub Copilot CLI..."
    npm install -g @githubnext/github-copilot-cli
}

main() {
    # Check if Homebrew is installed, install if not
    if ! command -v brew >/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

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
    source_zsh_config
    reload_tmux_config
    install_github_copilot
    install_copilot_cli
}

main