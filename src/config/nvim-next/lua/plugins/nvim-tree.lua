return {
  'nvim-tree/nvim-tree.lua',
  -- We want the tree to load at start
  event = 'VimEnter',
  opts = {},
  -- opts = {
  --   hijack_directories = {
  --     enable = false,
  --     auto_open = false,
  --   },
  -- },
  init = function()
    -- Don't load netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- local provided_file = vim.fn.argv(0)

    -- if provided_file ~= nil
    -- end

    -- Open the tree on start
    -- require('nvim-tree.api').tree.open()
  end,
}
