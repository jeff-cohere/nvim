-- packer: a Lua package manager that's NOT LazyVim!

-- install packer if it's not already familiar
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)

  -- packer, manage thyself
  use 'wbthomason/packer.nvim'

  -- snazzy buffer line
  use {
    'akinsho/bufferline.nvim',
    config = function()
      require("bufferline").setup{}
    end,
    requires = 'nvim-tree/nvim-web-devicons',
    tag = "*",
  }

  -- improved default UI
  use 'stevearc/dressing.nvim'

  -- search-label-powered navigation
  use 'folke/flash.nvim'

  -- git integration within buffers
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  }

  -- indent guides
  use 'lukas-reineke/indent-blankline.nvim'

  -- lua-rocket-powered status line
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup()
    end,
    options = {
      theme = 'gruvbox',
    },
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  }

  -- a package manager for language servers, linters, etc: super dweeb stuff
  use {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  }
  use {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
  }

  -- pre-fab config files for language servers
  use {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.gopls.setup{}
      lspconfig.clangd.setup{}
      lspconfig.pyright.setup{}
      lspconfig.rust_analyzer.setup{ 
        -- Server-specific settings. See `:help lspconfig-setup`
        settings = {
          ['rust-analyzer'] = {},
        },
      }
    end,
  }

  -- file manager in a buffer
  use {
    'nvim-neo-tree/neo-tree.nvim',
    config = function() 
      require("neo-tree").setup{}
    end,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
  }

  -- UI component library
  use 'MunifTanjim/nui.nvim'

  -- crazy-ass find/replace with dark powers
  --use 'nvim-pack/nvim-spectre'

  -- syntax highlighting, kicked up a notch
  --use {
  --  "nvim-treesitter/nvim-treesitter",
  --  run = function()
  --    require("nvim-treesitter.install").update({ with_sync = true })
  --  end,
  --  config = function()
  --    require("configs.treesitter")
  --  end,
  --}
  --use {
  --  "windwp/nvim-ts-autotag",
  --  after = "nvim-treesitter",
  --}
  --use 'nvim-treesitter/nvim-treesitter-textobjects'
  --]]

  -- "all the lua functions I don't want to write twice"
  use 'nvim-lua/plenary.nvim'

  -- highlighter of TODO:, FIXME:, and other such comments
  use 'folke/todo-comments.nvim'

  -- cutesy little diagnostic doots
  use 'folke/trouble.nvim'

  -- improved auto-formatting of code comments
  use 'folke/ts-comments.nvim'

  -- clippy for key bindings
  use 'folke/which-key.nvim'

  -- "fast as FUCK" auto-completion
  use 'ms-jpq/coq_nvim'

  -- highlight trailing whitespace
  --use 'bronson/vim-trailing-whitespace'

  -- Which lines have changed since our last Git commit?
  --use 'airblade/vim-gitgutter'

  -------------------
  -- color schemes --
  -------------------

  -- gruvbox is best girl
  use 'ellisonleao/gruvbox.nvim'

  -- tokyonight is alright
  use 'folke/tokyonight.nvim'

  -- oldies but goodies
  use 'iCyMind/NeoSolarized'
  use 'drewtempelmeyer/palenight.vim'
  use 'rakr/vim-one'
  use 'mhartington/oceanic-next'

  ---------------
  -- postamble --
  ---------------
  if packer_bootstrap then
    require('packer').sync()
  end
end)
