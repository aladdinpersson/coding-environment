#!/bin/zsh

update_and_upgrade() {
    echo "Updating package lists..."
    sudo apt-get update -y
    echo "Upgrading installed packages..."
    sudo apt-get upgrade -y
    echo "installing cmake..." 
    sudo apt install build-essential cmake -y
}

# Install zsh and make it your main shell
install_zsh() {
    sudo apt install -y zsh
    chsh -s $(which zsh)
}

# Install oh-my-zsh
install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Install Miniconda
install_miniconda() {
    local MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    local MINICONDA_SCRIPT="Miniconda3-latest-Linux-x86_64.sh"
    
    # Download Miniconda installation script
    curl -LO $MINICONDA_URL

    # Run the Miniconda installation script
    bash $MINICONDA_SCRIPT -b -p $HOME/miniconda3

    # Initialize Miniconda for Zsh
    $HOME/miniconda3/bin/conda init zsh

    # Remove the installation script
    rm $MINICONDA_SCRIPT
}

install_latest_nodejs_and_npm() {
    NODE_MAJOR=20  # Replace with desired version (e.g., 16, 18, 20, 21)

    # Update system package list and install prerequisites
    sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg

    # Set up the NodeSource repository
    sudo mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

    # Install Node.js and update npm to the latest version
    sudo apt-get update && sudo apt-get install -y nodejs && sudo npm install -g npm@latest

    # Verify the installation
    echo "Node.js $(node --version) and npm $(npm --version) have been installed successfully."
}


# Install TMUX
install_tmux() {
    sudo apt install -y tmux
}

# Install Neovim from the unstable PPA
install_neovim() {
    # Add the official Neovim 'unstable' PPA
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    
    # Update the package lists
    sudo apt update
    
    # Install Neovim
    sudo apt install -y neovim
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
clone_zsh_syntax_highlighting() {
    local ZSH_SYNTAX_HIGHLIGHTING_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    
    if [[ ! -d $ZSH_SYNTAX_HIGHLIGHTING_PATH ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_SYNTAX_HIGHLIGHTING_PATH
    else
        echo "zsh-syntax-highlighting directory already exists. Skipping clone."
    fi
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

# Install Github Copilot to Neovim
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
    sudo npm install -g @githubnext/github-copilot-cli
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
    clone_zsh_syntax_highlighting
    install_zsh_autosuggestions
    install_powerlevel10k
    install_tpm
    source_zsh_config
    reload_tmux_config
    install_github_copilot
    install_copilot_cli
}

main