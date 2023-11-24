#!/bin/zsh

# Install zsh and make it your main shell
install_zsh() {
    brew install zsh
    chsh -s /bin/zsh
}

# Install oh-my-zsh
install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
)"
}
# Install node.js 
install_node() {
    brew install node
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
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    ln -sf $DIR/.zshrc ~/.zshrc
    ln -sf $DIR/.tmux.conf ~/.tmux.conf
    ln -sf $DIR/nvim ~/.config/nvim
}

# Clone the zsh-syntax-highlighting plugin
clone_zsh_syntax_highlighting() {
    local ZSH_SYNTAX_HIGHLIGHTING_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    
    if [[ ! -d $ZSH_SYNTAX_HIGHLIGHTING_PATH ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
 $ZSH_SYNTAX_HIGHLIGHTING_PATH
    else
        echo "zsh-syntax-highlighting directory already exists. Skipping clone."
    fi
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
    install_node
    install_tmux
    install_neovim
    create_symbolic_links
    clone_zsh_syntax_highlighting
    add_github_copilot
    source_zsh_config
    reload_tmux_config
}

main
