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

    -- mason: a package manager for language servers, linters, etc: super dweeb stuff
    {
      "mason-org/mason.nvim",
      version = "1.11.0", -- FIXME: pinned cuz breakage
      opts = {}
    },
    --{
    --  "mason-org/mason-lspconfig.nvim",
    --  version = "1.32.0", -- FIXME: pinned cuz breakage
    --  opts = {},
    --  dependencies = {
    --    { "mason-org/mason.nvim", opts = {} },
    --    "neovim/nvim-lspconfig",
    --  },
    --},

    -- navbuddy: breadcrumbs for LSPs
    {
      'hasansujon786/nvim-navbuddy',
       dependencies = {
         'SmiteshP/nvim-navic',
         'MunifTanjim/nui.nvim'
       },
    },

    -- language server configuration (see lsp.lua for details)
    --{'hrsh7th/cmp-nvim-lsp', lazy = true},
    --{
    --  'neovim/nvim-lspconfig',
    --  dependencies = {
    --    {
    --      "hasansujon786/nvim-navbuddy",
    --      dependencies = {
    --        "SmiteshP/nvim-navic",
    --        "MunifTanjim/nui.nvim"
    --      },
    --      opts = { lsp = { auto_attach = true } }
    --    }
    --  },
    --  config = function()
    --    require('lsp')
    --  end,
    --},

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

    -- string case conversion
    {
      "johmsalas/text-case.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("textcase").setup({})
        require("telescope").load_extension("textcase")
      end,
      keys = {
        "ga", -- Default invocation prefix
        { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
      },
      cmd = {
        -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
        "Subs",
        "TextCaseOpenTelescope",
        "TextCaseOpenTelescopeQuickChange",
        "TextCaseOpenTelescopeLSPChange",
        "TextCaseStartReplacingCommand",
      },
      -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
      -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
      -- available after the first executing of it or after a keymap of text-case.nvim has been used.
      lazy = false,
    },

    -- buffer manager in a floating window
    {
      'j-morano/buffer_manager.nvim',
      config = function()
        require("buffer_manager").setup{}
      end,
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
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    },

    -- cutesy little diagnostic doots
    'folke/trouble.nvim',

    -- improved auto-formatting of code comments
    'folke/ts-comments.nvim',

    -- clippy for key bindings
    'folke/which-key.nvim',

    -- hex editing
    {'RaafatTurki/hex.nvim'},

    -- neovim-flavored auto-completion
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',
    
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'super-tab' },
    
        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },
    
        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },
    
        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    
        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },

    --{
    --  'hrsh7th/nvim-cmp',
    --  config = function()
    --    local cmp = require('cmp')
    --
    --    -- true iff e.g. the cursor is in the middle of a word
    --    local has_words_before = function()
    --      local cursor = vim.api.nvim_win_get_cursor(0)
    --      return cursor[2] ~= 0 and
    --             (vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1] or ''):sub(cursor[2], cursor[2]):match('%s') == nil
    --    end

    --    -- pass this to cmp.select_{prev/next}_item for insert-selection-in-situ
    --    local select_opt = {behavior = cmp.SelectBehavior.Insert}
    --    -- key mapping function for supertab <CR>, <Space>
    --    local close_and_passthrough = function(fallback)
    --      cmp.close()
    --      fallback()
    --    end
    --    -- key mapping function for supertab <BS>
    --    local close_if_empty_and_passthrough = function(fallback)
    --      if not has_words_before() then
    --        cmp.close()
    --      end
    --      fallback()
    --    end

    --    cmp.setup{
    --      completion = {
    --        autocomplete = false, -- not while I'm typing, please
    --      },

    --      snippet = {
    --        expand = function(args)
    --          -- a snippet engine is required by nvim-cmp :-/
    --          -- fortunately, vim 0.10+ has its own
    --          vim.snippet.expand(args.body)
    --        end,
    --      },

    --      formatting = {
    --        format = function(entry, vim_item)
    --          -- fancy icons and a name of kind
    --          local import_lspkind, lspkind = pcall(require, "lspkind")
    --          if import_lspkind then
    --            vim_item.kind = lspkind.presets.default[vim_item.kind]
    --          end

    --          -- limit completion width
    --          local ELLIPSIS_CHAR = '…'
    --          local MAX_LABEL_WIDTH = 35
    --          local label = vim_item.abbr
    --          local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
    --          if truncated_label ~= label then
    --            vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
    --          end

    --          -- set a name for each source
    --          vim_item.menu = ({
    --            buffer = "[Buffer]",
    --            nvim_lsp = "[LSP]",
    --            path = "[Path]",
    --          })[entry.source.name]
    --          return vim_item
    --        end,
    --      },

    --      sources = {
    --        {
    --          name = 'nvim_lsp',
    --          group_index = 1,
    --          keyword_length = 3,
    --        },
    --        {
    --          name = 'path',
    --          group_index = 1,
    --          keyword_length = 4,
    --        },
    --        {
    --          name = 'buffer',
    --          group_index = 2,
    --          keyword_length = 3,
    --        },
    --      },
    --
    --      -- preselect a menu item
    --      preselect = cmp.PreselectMode.Item,

    --      -- supertab!
    --      mapping = cmp.mapping.preset.insert({
    --        -- <CR> and <Space> close the menu and do a passthrough
    --        ['<CR>'] = cmp.mapping(close_and_passthrough),
    --        ['<Space>'] = cmp.mapping(close_and_passthrough),
    --        ['<BS>'] = cmp.mapping(close_if_empty_and_passthrough),
    --        ['<Tab>'] = cmp.mapping(function(fallback) -- tab autocompletion
    --          if has_words_before() then -- not at beginning of line
    --            cmp.complete()
    --            cmp.select_next_item(select_opt)
    --          elseif cmp.visible() then -- completion menu present
    --            cmp.select_next_item(select_opt)
    --          else -- sometimes a <Tab> is just a <Tab>
    --            fallback()
    --          end
    --        end, { 'i', 's' }),
    --        ['<S-Tab>'] = cmp.mapping(function(fallback) -- shift-tab backwards
    --          if cmp.visible() then
    --            cmp.select_prev_item(select_opt)
    --          else
    --            fallback()
    --          end
    --        end, { 'i', 's' }),
    --      }),

    --      window = {
    --        completion = cmp.config.window.bordered(),
    --        documentation = cmp.config.window.bordered(),
    --      },
    --    }
    --  end,

    --  dependencies = {
    --    'nvim-lspconfig',
    --    'hrsh7th/cmp-nvim-lsp',
    --    'hrsh7th/cmp-buffer',
    --    'hrsh7th/cmp-path',
    --    'hrsh7th/cmp-cmdline',
    --  },
    --},

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
