-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt_local.relativenumber = false -- absolute line numbers only, please
vim.g.autoformat = false             -- please STOP FUCKING WITH MY CODE
if vim.opt.colorcolumn then
  vim.opt.colorcolumn = '80'
  vim.cmd('highlight ColorColumn ctermbg=9')
end
