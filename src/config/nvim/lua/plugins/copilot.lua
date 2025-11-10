return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  -- event = 'InsertEnter',
  event = 'VimEnter',
  -- dependencies = {
  -- For NES functionality
  --"copilotlsp-nvim/copilot-lsp"
  -- },
  -- We need this to be loaded first
  dependencies = { 'folke/sidekick.nvim' },
  config = function()
    -- require('copilot').setup {
    --   server = {
    --     type = 'binary',
    --   },
    -- }
    require('copilot').setup {
      -- suggestion = {
      -- We need to figure out how to enable this on keymap
      -- auto_trigger = false,
      -- },
      server_opts_overrides = {
        handlers = {
          didChangeStatus = require('sidekick.status').on_status,
        },
      },
      logger = {
        file_log_level = vim.log.levels.TRACE,
        print_log_level = vim.log.levels.WARN,
        trace_lsp = 'verbose',
        log_lsp_messages = true,
        trace_lsp_progress = true,
      },
    }
  end,
}
