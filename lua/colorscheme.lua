local colorschemes = {
  'gruvbox',
  'NeoSolarized',
  'OceanicNext',
  'tokyonight',
  'zaibatsu',
}

math.randomseed(os.time())
local selected = colorschemes[math.random(#colorschemes)]

local status, _ = pcall(vim.cmd, 'colorscheme ' .. selected)
if not status then
  vim.api.nvim_echo({
    { "Colorscheme not found: " .. selected, "ErrorMsg" },
  }, true, {})
end
