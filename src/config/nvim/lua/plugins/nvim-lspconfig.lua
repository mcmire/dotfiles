return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Mason must be loaded before its dependents so we need to set it up here.
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },
    -- Allows extra capabilities provided by blink.cmp
    'saghen/blink.cmp',
  },
  config = function()
    -- The following language servers and tools will automatically be installed.
    --
    -- Available configuration options are:
    -- * cmd (table): Override the default command used to start the server.
    -- * filetypes (table): Override the default list of associated filetypes
    --   for the server.
    -- * capabilities (table): Override fields in capabilities. Can be used to
    --   disable certain LSP features.
    -- * settings (table): Override the default settings passed when
    --   initializing the server. For example, to see the options for `lua_ls`,
    --   you could go to: https://luals.github.io/wiki/settings/
    --
    -- See `:help lspconfig-all` for a list of all the pre-configured LSPs.
    --
    -- Some languages (like typescript) have entire language plugins that can be
    -- useful (e.g. https://github.com/pmizio/typescript-tools.nvim).
    -- But for many setups, the LSP (e.g.`ts_ls`) will work just fine.
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run:
    --
    --    :Mason
    --
    -- Make sure to update this list if you do choose to manually install
    -- anything.
    --
    local packages = {
      -- Copilot
      -- copilot = {},

      -- Lua
      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      stylua = {},

      -- JavaScript/TypeScript
      -- ts_ls = {},
      eslint = {},
      prettier = {},

      -- Python
      pyright = {},
    }

    -- This function gets run when an LSP attaches to a particular buffer.
    -- That is to say, every time a new file is opened that is associated with
    -- an LSP (for example, opening `main.rs` is associated with
    -- `rust_analyzer`) this function will be executed to configure the
    -- current buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Note that some of these keymaps are built in to Neovim already,
        -- we are just augmenting them or giving them descriptions.

        -- (Built in)
        -- Rename the variable under your cursor.
        -- Most Language Servers support renaming across files, etc.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- (Built in)
        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('<Leader>ca', function()
          print 'TIP: Use `gra` instead of `<Leader>ca` to open code actions.'
          vim.lsp.buf.code_action()
        end, 'Open [C]ode [A]ctions', { 'n', 'x' })

        local has_telescope, telescope = pcall(require, 'telescope.builtin')

        if has_telescope then
          -- (Built in)
          -- Find references for the word under your cursor.
          map('grr', telescope.lsp_references, '[G]oto [R]eferences')

          -- (Built in)
          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', telescope.lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', telescope.lsp_definitions, '[G]oto [D]efinition')

          -- (Built in)
          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', telescope.lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', telescope.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- (Built in)
          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', telescope.lsp_type_definitions, '[G]oto [T]ype Definition')
        else
          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          -- Old habits die hard
          vim.keymap.set('n', 'gd', 'grd', { buffer = event.buf, desc = 'LSP: [G]oto [D]efinition', remap = true })
        end

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Show documentation
        -- NOTE: Neovim already defines this but we want to customize the
        -- floating window
        -- vim.keymap.set('n', 'K', function()
        --   vim.lsp.buf.hover { offset_x = 2, offset_y = 2 }
        -- end, { buffer = event.buf, desc = 'LSP: Show documentation', remap = true })

        -- Show diagnostics in a floating window
        -- (alias for '<C-w>d')
        vim.keymap.set('n', '<Leader>d', '<C-w>d', { buffer = event.buf, desc = 'LSP: Show [D]iagnostics', remap = true })
        -- Jump to the next diagnostic
        -- (alias for ']d')
        vim.keymap.set('n', ']g', ']d', { buffer = event.buf, desc = 'LSP: Jump to next diagnostic', remap = true })
        -- Jump to the previous diagnostic
        -- (alias for '[d')
        vim.keymap.set('n', '[g', '[d', { buffer = event.buf, desc = 'LSP: Jump to previous diagnostic', remap = true })

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- Toggle inlay hints in your code, if the language server you are using
        -- supports them. Use with caution.
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>ih', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, 'Toggle [I]nlay [H]ints')
        end
      end,
    })

    -- Configure how diagnostics are shown
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      -- Don't show diagnostics as virtual text, as it tends to run off the
      -- screen. We will use `<Leader>d` to view them on demand.
      virtual_text = false,
    }

    -- LSP servers and clients are able to communicate to each other what
    -- features they support. By default, Neovim doesn't support everything that
    -- is in the LSP specification. When you add blink.cmp, luasnip, etc. Neovim
    -- now has *more* capabilities. So, we create new capabilities with
    -- blink.cmp, and then broadcast that to the servers.
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Ensure the servers and tools above are installed.
    -- (Surprisingly, Mason itself doesn't allow you to pre-specify a list
    -- like this.)
    -- Note that `mason` had to be set up earlier: to configure its options see
    -- the `dependencies` table for `nvim-lspconfig` above.
    require('mason-tool-installer').setup {
      ensure_installed = vim.tbl_keys(packages or {}),
    }

    -- Automatically enable all of the Mason-installed packages.
    require('mason-lspconfig').setup {}
  end,
}
