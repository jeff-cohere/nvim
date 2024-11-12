require('math')
require('os')

require('settings')
require('plugins')
require('mappings')

colorschemes = {
  'gruvbox',
  'tokyonight',
  'NeoSolarized',
  'palenight',
  'desert',
  'darkblue',
}
math.randomseed(os.time())
vim.cmd.colorscheme(colorschemes[math.random(#colorschemes)])
