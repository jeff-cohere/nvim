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
      config = function()
        require("bufferline").setup{}
      end,
      dependencies = 'nvim-tree/nvim-web-devicons',
      versions = '*',
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
        theme = 'gruvbox',
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
      after = {
        'mason.nvim',
        'nvim-lspconfig',
      },
      config = function()
        require("mason-lspconfig").setup{}
      end,
    },

    -- pre-fab config files for language servers
    {'hrsh7th/cmp-nvim-lsp', lazy = true},
    {
      'neovim/nvim-lspconfig',
      config = function()
        -- Show line diagnostics automatically in hover window
        vim.diagnostic.config{
          virtual_text = false,
        }
        vim.o.updatetime = 250
        vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

        -- lsp configuration
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

        -- context-dependent commands made available upon attaching to a language
        -- server with a relevant file
        vim.api.nvim_create_autocmd('LspAttach', {
          desc = 'LSP actions',
          callback = function(event)
            local opts = {buffer = event.buf}

            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
            vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
          end,
        })
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
        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and
          vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local cmp = require('cmp')

        local select_opts = {behavior = cmp.SelectBehavior.Select}
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
            {name = 'nvim_lsp', group_index = 1},
            {name = 'path', group_index = 1},
            {name = 'buffer', group_index = 2},
          },

          -- preselect a menu item
          preselect = cmp.PreselectMode.Item,

          -- supertab!
          mapping = cmp.mapping.preset.insert({
            ['<Enter>'] = cmp.mapping.confirm({select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback) -- tab autocompletion
              cmp.complete()
              if cmp.visible() then
                cmp.select_next_item(select_opts)
              elseif vim.snippet.active({direction = 1}) then
                require('snippets').expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
                cmp.select_next_item(select_opts)
              else
                fallback() -- sends mapped key (probably '<Tab>')
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback) -- shift-tab backwards
              if cmp.visible() then
                cmp.select_prev_item(select_opts)
              elseif vim.snippet.active({direction = -1}) then
                vim.snippet.jump(-1)
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

    -- support for snippets based on vim.snippet (neovim 0.10+)
    {
      "garymjr/nvim-snippets",
      create_cmp_source = true, -- creates 'snippets' source
      dependencies = {'hrsh7th/nvim-cmp'},
    },

    -------------------
    -- color schemes --
    -------------------

    -- gruvbox is best girl
    'ellisonleao/gruvbox.nvim',

    -- tokyonight is alright
    'folke/tokyonight.nvim',

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
