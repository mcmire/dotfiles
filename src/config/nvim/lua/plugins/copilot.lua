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
  -- dependencies = { 'folke/sidekick.nvim' },
  config = function()
    -- require('copilot').setup {
    --   server = {
    --     type = 'binary',
    --   },
    -- }
    require('copilot').setup {
      suggestion = {
        auto_trigger = true,
      },
      server_opts_overrides = {
        handlers = {
          didChangeStatus = require('sidekick.status').on_status,
        },
      },
    }
  end,
}
