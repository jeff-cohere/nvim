local colorschemes = {
  'blue',
  'gruvbox',
  'habamax',
  'murphy',
  'NeoSolarized',
  'OceanicNext',
  'one',
  'ron',
  'slate',
  'tokyonight',
  'torte',
  'unokai',
}

math.randomseed(os.time())
local selected = colorschemes[math.random(#colorschemes)]
selected = 'NeoSolarized' -- for now

local status, _ = pcall(vim.cmd, 'colorscheme ' .. selected)
if not status then
  vim.api.nvim_echo({
    { "Colorscheme not found: " .. selected, "ErrorMsg" },
  }, true, {})
end
