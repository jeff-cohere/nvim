-- disable UTF-8
--vim.opt.encoding = 'iso-8859-15'
--vim.opt.fileencoding = 'iso-8859-15'

-- show the 80th column
if vim.opt.colorcolumn then
  vim.opt.colorcolumn = '80'
  vim.cmd('highlight ColorColumn ctermbg=9')
end

-- allow mouse selection
vim.opt.mouse='a'

-- use the mouse to change focus between split windows
--vim.opt.mousefocus=true

-- try to set the color scheme
vim.opt.termguicolors=true
vim.opt.background='dark'
local success, result = pcall(function()
  vim.cmd.colorscheme('gruvbox')
end)

vim.opt.foldmethod='indent'
vim.opt.foldenable=false

-- don't wrap lines
vim.opt.wrap=false

-- total number of visible columns
--vim.opt.columns=80

-- automagically indent
vim.opt.autoindent=true
vim.opt.smartindent=true

-- automagically write changes to a file when using rxternal commands
vim.opt.autowrite=true

-- Expand tabs.
vim.opt.et=true

-- 1 tab = 2 spaces
vim.opt.softtabstop=2
vim.opt.shiftwidth=2
vim.opt.tabstop=2

-- no backups, please
vim.opt.backup=false
vim.opt.writebackup=false

-- search for words as they are typed
vim.opt.incsearch=true

-- Highlight matched search tokens.
vim.opt.hlsearch=true
vim.cmd([[
highlight Search guibg=maroon
highlight Search ctermbg=9
]])

-- visual bell
vim.opt.visualbell=false

-- show matched parens
vim.opt.showmatch=true

-- split new windows below old ones
vim.opt.splitbelow=true

-- allow lots of mistakes
vim.opt.undolevels=1024

-- don't fret about vi
vim.opt.compatible=false

-- special character support
vim.opt.digraph=true

-- case insensitive searching
vim.opt.ignorecase=true

-- don't update the screen when using macros
vim.opt.lazyredraw=true

-- use a ruler at the bottom line to indicate location in a file
vim.opt.ruler=true

-- highlight non-ASCII characters
vim.cmd([[
syntax match nonascii "[^\x00-\x7F]"
highlight nonascii guibg=Red ctermbg=2
]])
