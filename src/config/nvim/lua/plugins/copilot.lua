return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  -- dependencies = {
  -- For NES functionality
  --"copilotlsp-nvim/copilot-lsp"
  -- },
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
    }
  end,
}
