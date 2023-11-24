local opt = vim.opt -- for conciseness


-- line numbers
opt.relativenumber = true opt.number = true

-- tabs & indentation
opt.softtabstop = 4
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
--opt.autoindent = true
opt.smartindent = true

--line wrapping
opt.wrap = false

--search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false 
opt.incsearch = true

--cursor line 
opt.cursorline = true

--appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

--backspace
opt.backspace = "indent,eol,start"

--clipboard
opt.clipboard:append("unnamedplus")

--split screen
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")
