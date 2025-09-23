-- Telescope is a fuzzy finder that comes with a lot of different things that it
-- can fuzzy find! It's more than just a "file finder", it can search many
-- different aspects of Neovim, your workspace, LSP, and more!
--
-- The easiest way to use Telescope, is to start by doing something like:
--
--   :Telescope help_tags
--
-- After running this command, a window will open up and you're able to type in
-- the prompt window. You'll see a list of `help_tags` options and a
-- corresponding preview of the help.
--
-- Two important keymaps to use while in Telescope are:
--
-- * Insert mode: <c-/>
-- * Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Telescope picker. This is really useful to discover what Telescope can do as
-- well as how to actually do it!
--
-- To configure Telescope, see `:help telescope` and `:help telescope.setup()`.

return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        -- Install when make is available
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      -- Repoints vim.ui.select to use Telescope.
      -- This means for example that Neovim core stuff can fill the telescope picker.
      -- Example would be `vim.lsp.buf.code_action()`.
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      -- [Use pcall to discard errors]
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<Leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<Leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<Leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      -- Compatibility with Ctrl-P
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<Leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      --vim.keymap.set('n', '<Leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<Leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      --vim.keymap.set('n', '<Leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      --vim.keymap.set('n', '<Leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      --vim.keymap.set('n', '<Leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      --vim.keymap.set('n', '<Leader>sb', builtin.buffers, { desc = '[S]earch existing [B]uffers' })
      vim.keymap.set('n', '<Leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<Leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
    end,
  },
}
