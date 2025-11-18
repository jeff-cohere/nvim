------------------------
-- LSP Configurations --
------------------------

-- show line diagnostics automatically in hover window
vim.diagnostic.config{
  virtual_text = false,
}
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- lsp configuration
--local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- c/c++/objective-c/etc
vim.lsp.config.clangd = {
  capabilities = capabilities,
  cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = false
  },

  on_attach = function() -- specific key bindings
  end,

  -- uncomment this to disable semantic highlighting
  --on_init = function(client)
  --            client.server_capabilities.semanticTokensProvider = nil
  --          end,
}

 -- go
vim.lsp.config.gopls = {
  capabilities = capabilities,
  cmd = {'gopls'},
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
  on_attach = function() -- specific key bindings
  end,
}

-- odin
vim.lsp.config.ols = {}

-- lua
vim.lsp.config.lua_ls = {
  capabilities = capabilities,

  on_attach = function() -- specific key bindings
  end,

  settings = {
    Lua = {
      diagnostics = {
        globals = {
          'love', -- game development
          'vim',  -- neovim API
        },
      },
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        maxPreload = 10000,
        preloadFileSize = 1000,
      },
    },
  },
}

-- python
vim.lsp.config.pyright = {
  capabilities = capabilities,

  on_attach = function() -- specific key bindings
  end,
}

-- rust
vim.lsp.config.rust_analyzer = {
  capabilities = capabilities,
  on_attach = function() -- specific key bindings
  end,
  settings = {
    ['rust-analyzer'] = {},
  },
}


-- context-dependent commands made available upon attaching to a language
-- server with a relevant file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local opts = {buffer = event.buf}
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end

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

-- set this to "debug" if you think it might help
vim.lsp.log.set_level("off")

vim.api.nvim_create_user_command("LspLogClear", function()
	local lsplogpath = vim.fn.stdpath("state") .. "/lsp.log"
	if io.close(io.open(lsplogpath, "w+b")) == false then vim.notify("Clearing LSP Log failed.", vim.log.levels.WARN) end
end, { nargs = 0 })

vim.lsp.enable({
  'clangd',
  'gopls',
  'lua_ls',
  'rust-analyzer'
})
