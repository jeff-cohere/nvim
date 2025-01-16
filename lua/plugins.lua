-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- configure plugins
require("lazy").setup({
  spec = {

    -- snazzy buffer line
    {
      'akinsho/bufferline.nvim',
      dependencies = 'nvim-tree/nvim-web-devicons',
      version = '*',
    },

    -- improved default UI
    'stevearc/dressing.nvim',

    -- search-label-powered navigation
    'folke/flash.nvim',

    -- git integration within buffers
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup{}
      end,
    },

    -- indent guides
    {
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require("ibl").setup{}
      end,
    },

    -- lua-rocket-powered status line
    {
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lualine').setup{}
      end,
      options = {
        theme = 'auto',
      },
      dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
    },

    -- a package manager for language servers, linters, etc: super dweeb stuff
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup{}
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require("mason-lspconfig").setup{
          -- looks like this vvv requires npm, which is gross
          --ensure_installed = {
          --  "bashls",
          --  "clangd",
          --  "cssls",
          --  "dockerls",
          --  "gopls",
          --  "html",
          --  "jsonls",
          --  "pyright",
          --  "sqlls",
          --  "yamlls"
          --},
        }
      end,
      dependencies = {
        'mason.nvim',
        'nvim-lspconfig',
      },
    },

    -- language server configuration (see lsp.lua for details)
    {'hrsh7th/cmp-nvim-lsp', lazy = true},
    {
      'neovim/nvim-lspconfig',
      config = function()
        require('lsp')
      end,
    },

    -- treesitter fancypants syntax highlighting
    {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require('nvim-treesitter.configs').setup {
          -- a list of parser names, or "all" (the listed parsers MUST always be installed)
          ensure_installed = { "c", "go", "lua", "vim", "vimdoc", "query",
                               "markdown", "markdown_inline" },

          -- install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,

          -- automatically install missing parsers when entering buffer
          -- (set to false if you don't have `tree-sitter` CLI installed locally)
          auto_install = false,

          -- list of parsers to ignore installing (or "all")
          ignore_install = { "javascript" },

          highlight = {
            enable = true,

            -- disabled parsers (NOTE: parser names, not file type names)
            --disable = {"c", "rust" },
            -- NOTE: can also use a function for more flexibility
            --disable = function(lang, buf)
            --end,

            -- setting to true will run `:h syntax` and tree-sitter at the same
            -- time
            additional_vim_regex_highlighting = false,
          },
        }
      end
    },

    -- file manager in a buffer
    {
      'nvim-neo-tree/neo-tree.nvim',
      config = function()
        require("neo-tree").setup{}
      end,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      },
    },

    -- UI component library
    'MunifTanjim/nui.nvim',

    -- "all the lua functions I don't want to write twice"
    'nvim-lua/plenary.nvim',

    -- highlighter of TODO:, FIXME:, and other such comments
    'folke/todo-comments.nvim',

    -- cutesy little diagnostic doots
    'folke/trouble.nvim',

    -- improved auto-formatting of code comments
    'folke/ts-comments.nvim',

    -- clippy for key bindings
    'folke/which-key.nvim',

    -- neovim-flavored auto-completion
    {
      'hrsh7th/nvim-cmp',
      config = function()
        local cmp = require('cmp')

        -- true iff e.g. the cursor is in the middle of a word
        local has_words_before = function()
          local cursor = vim.api.nvim_win_get_cursor(0)
          return cursor[2] ~= 0 and
                 (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''):sub(cursor[2], cursor[2]):match('%s') == nil
        end

        -- pass this to cmp.select_{prev/next}_item for insert-selection-in-situ
        local select_opt = {behavior = cmp.SelectBehavior.Insert}
        -- key mapping function for supertab <CR>, <Space>
        local close_and_passthrough = function(fallback)
          cmp.close()
          fallback()
        end
        -- key mapping function for supertab <BS>
        local close_if_empty_and_passthrough = function(fallback)
          if not has_words_before() then
            cmp.close()
          end
          fallback()
        end

        cmp.setup{
          completion = {
            autocomplete = false, -- not while I'm typing, please
          },

          snippet = {
            expand = function(args)
              -- a snippet engine is required by nvim-cmp :-/
              -- fortunately, vim 0.10+ has its own
              vim.snippet.expand(args.body)
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
              })[entry.source.name]
              return vim_item
            end,
          },

          sources = {
            {
              name = 'nvim_lsp',
              group_index = 1,
              keyword_length = 3,
            },
            {
              name = 'path',
              group_index = 1,
              keyword_length = 4,
            },
            {
              name = 'buffer',
              group_index = 2,
              keyword_length = 3,
            },
          },

          -- preselect a menu item
          preselect = cmp.PreselectMode.Item,

          -- supertab!
          mapping = cmp.mapping.preset.insert({
            -- <CR> and <Space> close the menu and do a passthrough
            ['<CR>'] = cmp.mapping(close_and_passthrough),
            ['<Space>'] = cmp.mapping(close_and_passthrough),
            ['<BS>'] = cmp.mapping(close_if_empty_and_passthrough),
            ['<Tab>'] = cmp.mapping(function(fallback) -- tab autocompletion
              if has_words_before() then -- not at beginning of line
                cmp.complete()
                cmp.select_next_item(select_opt)
              elseif cmp.visible() then -- completion menu present
                cmp.select_next_item(select_opt)
              else -- sometimes a <Tab> is just a <Tab>
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback) -- shift-tab backwards
              if cmp.visible() then
                cmp.select_prev_item(select_opt)
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),

          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
        }
      end,

      dependencies = {
        'nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
      },
    },

    -------------------
    -- color schemes --
    -------------------

    -- gruvbox is best girl
    {
      'ellisonleao/gruvbox.nvim',
      priority = 1000,
    },

    -- tokyonight is alright
    'folke/tokyonight.nvim',

    -- melange is the new warmness
    'savq/melange-nvim',

    -- oldies but goodies
    'iCyMind/NeoSolarized',
    'drewtempelmeyer/palenight.vim',
    'rakr/vim-one',
    'mhartington/oceanic-next',

  },

  -- colorscheme used when installing plugins
  install = { colorscheme = { "vim-one" } },

  -- automatically check for plugin updates?
  checker = { enabled = false },
})
