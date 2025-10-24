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
  opts = {
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
}
