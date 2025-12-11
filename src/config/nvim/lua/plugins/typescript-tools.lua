local utils = require '../utils'

return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    settings = {
      tsserver_file_preferences = {
        -- importModuleSpecifierPreference = 'project-relative',
      },
    },
    root_dir = function(bufnr, on_dir, extra)
      local root_dir = utils.get_typescript_project_dir(bufnr)

      -- Sometimes on_dir is a number, not sure why
      if root_dir ~= nil and type(on_dir) == 'function' then
        on_dir(root_dir)
      end
    end,
  },
}
