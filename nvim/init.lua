require("mrbean.plugins-setup")
require("mrbean.core.options")
require("mrbean.core.keymaps")
require("mrbean.core.colorscheme")
require("mrbean.plugins.comment")
require("mrbean.plugins.nvim-tree")
require("mrbean.plugins.lualine")
require("mrbean.plugins.telescope")

local undodir = vim.fn.expand('~/.undodir')

-- Create the undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
  os.execute('mkdir -p ' .. undodir)
end

-- Set the undodir and enable undofile
vim.opt.undodir = undodir
vim.opt.undofile = true