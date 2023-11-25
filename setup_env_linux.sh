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

# Install node.js 
install_node() {
    sudo apt install -y nodejs
}

# Install TMUX
install_tmux() {
    sudo apt install -y tmux
}

# Install Neovim
install_neovim() {
    # Add the official Neovim PPA
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    
    # Update the package lists
    sudo apt update
    
    # Install Neovim
    sudo apt install -y neovim
}

# Create symbolic links
create_symbolic_links() {
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    ln -sf $DIR/.zshrc ~/.zshrc
    ln -sf $DIR/.tmux.conf ~/.tmux.conf
    ln -sf $DIR/nvim ~/.config/nvim
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

# Add Github Copilot to Neovim
add_github_copilot() {
    local COPILOT_DIR="$HOME/.config/nvim/pack/github/start/copilot.vim"
    if [[ ! -d $COPILOT_DIR ]]; then
        mkdir -p $HOME/.config/nvim/pack/github/start
        git clone https://github.com/github/copilot.vim.git $COPILOT_DIR
    else
        echo "Github Copilot directory already exists. Skipping clone."
    fi
}

main() {
    install_zsh
    install_oh_my_zsh
    install_miniconda
    install_node
    install_tmux
    install_neovim
    create_symbolic_links
    clone_zsh_syntax_highlighting
    install_zsh_autosuggestions
    install_powerlevel10k
    install_tpm
    add_github_copilot
    source_zsh_config
    reload_tmux_config
}

main
