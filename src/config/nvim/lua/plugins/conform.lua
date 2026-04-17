return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre', 'BufWritePost' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<Leader>F',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style, and for slow formatters (like
      -- Prettier).
      local disable_filetypes = { c = true, cpp = true, javascript = true, typescript = true, json = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          lsp_format = 'fallback',
          timeout_ms = 500,
        }
      end
    end,
    format_after_save = function(bufnr)
      -- Only use this hook for slow formatters (like Prettier).
      -- See <https://github.com/stevearc/conform.nvim/issues/401#issuecomment-2108453243>
      local enable_filetypes = { javascript = true, typescript = true, json = true }
      if enable_filetypes[vim.bo[bufnr].filetype] then
        return {
          lsp_format = 'fallback',
        }
      else
        return nil
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'oxfmt', 'prettierd', stop_after_first = true },
      typescript = { 'oxfmt', 'prettierd', stop_after_first = true },
      json = { 'oxfmt', 'prettierd', stop_after_first = true },

      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
    },
    formatters = {
      oxfmt = {
        condition = function(self, ctx)
          local project_with_oxfmt_config = vim.fs.root(ctx.dirname, {
            '.oxfmtrc.json',
            '.oxfmtrc.jsonc',
            'oxfmt.config.ts',
          })
          if project_with_oxfmt_config then
            return true
          end

          local project_with_package_json = vim.fs.root(ctx.dirname, { 'package.json' })
          if project_with_package_json then
            local package_json_path = vim.fs.joinpath(project_with_package_json, 'package.json')
            local ok, data = pcall(function()
              return vim.json.decode(table.concat(vim.fn.readfile(package_json_path), '\n'))
            end)
            if ok and data then
              local deps = data.dependencies or {}
              local dev_deps = data.devDependencies or {}
              if deps['oxfmt'] or dev_deps['oxfmt'] then
                return true
              end
            end
          end

          return false
        end,
      },
      prettierd = {
        condition = function(self, ctx)
          local project_with_prettier_config = vim.fs.root(ctx.dirname, {
            '.prettierrc',
            '.prettierrc.cjs',
            '.prettierrc.cts',
            '.prettierrc.js',
            '.prettierrc.json',
            '.prettierrc.json5',
            '.prettierrc.mjs',
            '.prettierrc.mts',
            '.prettierrc.toml',
            '.prettierrc.ts',
            '.prettierrc.yaml',
            '.prettierrc.yml',
            'prettier.config.cjs',
            'prettier.config.cts',
            'prettier.config.js',
            'prettier.config.mjs',
            'prettier.config.mts',
            'prettier.config.ts',
          })
          if project_with_prettier_config then
            return true
          end

          local project_with_package_json = vim.fs.root(ctx.dirname, { 'package.json' })
          if project_with_package_json then
            local package_json_path = vim.fs.joinpath(project_with_package_json, 'package.json')
            local ok, data = pcall(function()
              return vim.json.decode(table.concat(vim.fn.readfile(package_json_path), '\n'))
            end)
            if ok and data then
              local deps = data.dependencies or {}
              local dev_deps = data.devDependencies or {}
              if deps['prettier'] or dev_deps['prettier'] then
                return true
              end
            end
          end

          return false
        end,
      },
    },
  },
}
