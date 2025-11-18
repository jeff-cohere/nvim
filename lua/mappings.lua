------------------
-- Key Mappings --
------------------

-- jump to next and previous compile errors
vim.keymap.set('n', ']g', vim.diagnostic.goto_next)
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)

-- jump to definition
vim.keymap.set('n', 'gD', vim.lsp.buf.definition, { desc = 'LSP: go to definition' })
vim.keymap.set('n', 'grt', vim.lsp.buf.type_definition, { desc = 'LSP: type definition' })

-- LSP completion
vim.keymap.set('i', '<Tab>', function()
  vim.lsp.completion.get()
end)

-- buffer management
vim.keymap.set('n', '<C-X>', function()
  require("buffer_manager.ui").toggle_quick_menu()
end)

-- toggle file manager
vim.keymap.set('n', '<C-F>', function()
  vim.cmd([[:Neotree filesystem reveal_force_cwd=true action=show toggle=true]])
end)

-- toggle line numbers
vim.keymap.set('n', '<C-L>', function()
  vim.wo.number = not vim.wo.number
end)

-- toggle hex editor mode
vim.keymap.set('n', '<C-H>', function()
  require 'hex'.toggle()
end)

-- toggle navigation buddy
vim.keymap.set('n', '<C-N>', require("nvim-navbuddy").open)

vim.cmd([[
" Ctrl-X lists current buffers.
"map <C-X> :buffers<CR>

" Ctrl-T toggles the tag list.
"map <C-T> :TlistToggle<CR>

" Ctrl-L toggles line numbers.
"map <C-L> :set number!<CR>

" Ctrl-F toggles folding.
"map <C-F> :set foldenable!<CR>

" Esc exits terminal mode.
tnoremap <Esc> <C-\><C-n>
]])

----------------------------- Code fun -----------------------------------

vim.cmd([[
ab csep //------------------------------------------------------------------------

ab fsep !------------------------------------------------------------------------
]])
