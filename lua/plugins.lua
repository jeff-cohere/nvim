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
      require('gitsigns').setup{}
    end,
  }

  -- indent guides
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("ibl").setup{}
    end,
  }

  -- lua-rocket-powered status line
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup{}
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
      require("mason").setup{}
    end,
  }
  use {
    "williamboman/mason-lspconfig.nvim",
    after = {
      'mason.nvim',
      'nvim-lspconfig',
    },
    config = function()
      require("mason-lspconfig").setup{}
    end,
  }

  -- pre-fab config files for language servers
  use {
    'neovim/nvim-lspconfig',
    config = function()
      -- Show line diagnostics automatically in hover window
      vim.diagnostic.config{
        virtual_text = false,
      }
      vim.o.updatetime = 250
      vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
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

  -- snippets for auto-completion
  use {
    'dcampos/nvim-snippy',
    config = function()
      require('snippy').setup{
        mappings = {
          is = {
            ['<Tab>'] = 'expand_or_advance',
            ['<S-Tab>'] = 'previous',
          },
          nx = {
            ['<leader>x'] = 'cut_text',
          },
        },
      }
    end,
  }

  -- neovim-flavored auto-completion
  use {
    'hrsh7th/nvim-cmp',
    after = {
      'nvim-snippy',
      'nvim-lspconfig'
    },
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      -- LSP configuration
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require('lspconfig')

      -- server-specific settings. See `:help lspconfig-setup`
      lspconfig.clangd.setup {
        capabilities = capabilities,
      }
      lspconfig.gopls.setup {
        capabilities = capabilities,
      }
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
      }
      lspconfig.pyright.setup {
        capabilities = capabilities,
      }
      lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {},
        },
      }

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and
          vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local snippy = require('snippy')
      local cmp = require('cmp')

      cmp.setup{
        completion = {
          autocomplete = false, -- not while I'm typing, please
        },

        snippet = {
          expand = function(args)
            snippy.expand_snippet(args.body)
          end,
        },

        formatting = {
          format = function(entry, vim_item)
            -- fancy icons and a name of kind
            local import_lspkind, lspkind = pcall(require, "lspkind")
            if import_lspkind then
              vim_item.kind = lspkind.presets.default[vim_item.kind]
            end

            -- limit completion width
            local ELLIPSIS_CHAR = '…'
            local MAX_LABEL_WIDTH = 35
            local label = vim_item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
            if truncated_label ~= label then
              vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
            end

            -- set a name for each source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              path = "[Path]",
              snippy = "[Snippy]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
            })[entry.source.name]
            return vim_item
          end,
        },

        sources = {
          {name = 'buffer', keyword_length = 3},
          {name = 'nvim_lsp'},
          {name = 'path'},
          {name = 'snippy'},
        },

        -- preselect a menu item
        preselect = cmp.PreselectMode.Item,

        mapping = {
          ['<CR>'] = cmp.mapping.confirm({ select = true }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif snippy.can_expand_or_advance() then
              snippy.expand_or_advance()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif snippy.can_jump(-1) then
              snippy.previous()
            else
              fallback()
            end
          end, { "i", "s" }),
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }
    end
  }

  use {
    'dcampos/cmp-snippy',
    after = {
      'nvim-cmp',
    },
    config = function()
      require('cmp').setup {
        snippet = {
          expand = function(args)
            require('snippy').expand_snippet(args.body)
          end
        },
        sources = {
          { name = 'snippy' },
        }
      }
    end
  }

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
