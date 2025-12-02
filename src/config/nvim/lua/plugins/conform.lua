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
      local disable_filetypes = { c = true, cpp = true, javascript = true, typescript = true }
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
      local enable_filetypes = { javascript = true, typescript = true }
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
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      json = { 'prettierd' },

      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },

      -- You can use 'stop_after_first' to run the first available formatter from the list
    },
  },
}
