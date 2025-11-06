return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  -- neo-tree lazily loads itself
  lazy = false,
  keys = {
    {
      '<Leader>tt',
      ':Neotree action=focus toggle=true<CR>',
      desc = 'Neo[T]ree: [T]oggle',
      silent = true,
    },
    {
      '<Leader>tf',
      ':Neotree action=focus reveal=true<CR>',
      desc = 'Neo[T]ree: [F]ocus current file',
      silent = true,
    },
  },
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    close_if_last_window = true,
    enable_git_status = false,
    default_component_configs = {
      popup_border_style = 'NC',
      icon = {
        folder_closed = ' ',
        folder_open = ' ',
        folder_empty = '󰜌 ',
        provider = function(icon, node)
          if node.type == 'file' or node.type == 'terminal' then
            local success, web_devicons = pcall(require, 'nvim-web-devicons')
            local name = node.type == 'terminal' and 'terminal' or node.name
            if success then
              local devicon, hl = web_devicons.get_icon(name)
              icon.text = (devicon or icon.text) .. ' '
              icon.highlight = hl or icon.highlight
            end
          end
        end,
        default = '',
      },
      git_status = {
        symbols = {
          -- Change type
          added = 'A',
          deleted = 'D',
          modified = 'M',
          renamed = 'R',
          -- Status type
          untracked = '?',
          ignored = '#',
          unstaged = 'O',
          staged = '@',
          conflict = 'x',
        },
      },
    },
    window = {
      mappings = {
        -- Compatibility with NERDTree
        ['i'] = 'open_split',
      },
    },
  },
  init = function()
    -- Don't load netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function should_open_tree()
      if vim.fn.argc() == 0 then
        return true
      end

      local first_arg = vim.fn.argv(0)

      if type(first_arg) == 'string' and vim.fn.argc() == 1 and vim.fn.isdirectory(first_arg) then
        return true
      end

      return false
    end

    if should_open_tree() then
      require('neo-tree.command').execute {
        action = 'show',
        reveal_file = vim.fn.getcwd(),
      }
    end
  end,
}
