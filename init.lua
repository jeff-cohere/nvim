require('settings')
require('plugins')

-- mappings
vim.cmd([[
" Ctrl-X lists current buffers.
map <C-X> :buffers<CR>

" Ctrl-T toggles the tag list.
map <C-T> :TlistToggle<CR>

" Ctrl-L toggles line numbers.
map <C-L> :set number!<CR>

" Ctrl-F toggles folding.
map <C-F> :set foldenable!<CR>

" Esc exits terminal mode.
tnoremap <Esc> <C-\><C-n>
]])

----------------------------- Code fun -----------------------------------

vim.cmd([[
ab csep //------------------------------------------------------------------------

ab fsep !------------------------------------------------------------------------
]])
