-- auto install packer if not installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
    return
end

-- add list of plugins to install
return packer.startup(function(use)
    -- packer can manage itself
    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim") -- lua functions that many plugins use
    use("bluz71/vim-nightfly-guicolors") -- preferred colorscheme
    use("christoomey/vim-tmux-navigator") -- tmux & split window navigation
    use("szw/vim-maximizer") -- maximizes and restores current window

    -- other essential plugins...
    use("numToStr/Comment.nvim")
    use("nvim-tree/nvim-tree.lua")
    use("nvim-tree/nvim-web-devicons")

    -- more plugins...
    use("nvim-lualine/lualine.nvim")
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })
    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
    use('nvim-treesitter/playground')
    use('mbbill/undotree')
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},
            --more requires...
        }
    }
    use("github/copilot.vim")

    -- more plugins...

    if packer_bootstrap then
        require("packer").sync()
    end
end)

-- Mason settings
local mason_servers = {
    'black',
    'css-lsp',
    'emmet-ls',
    'eslint_d',
    'html-lsp',
    'jedi-language-server',
    'lua-language-server',
    'prettier',
    'rust-analyzer',
    'stylua',
    'tailwindcss-language-server',
    'typescript-language-server',
}

-- Ensure Mason is set up properly with the required servers
require("mason").setup({
    ensure_installed = mason_servers,
    automatic_installation = false,
})

require("mason-lspconfig").setup({
    ensure_installed = mason_servers,
    automatic_installation = true,
})