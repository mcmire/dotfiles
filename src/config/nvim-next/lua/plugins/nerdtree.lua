return {
  'preservim/nerdtree',
  event = 'VimEnter',
  keys = {
    { '<Leader>tt', '<Cmd>NERDTreeToggle<CR>', desc = '[T]oggle [T]ree' },
    { '<Leader>tf', '<Cmd>NERDTree<CR><C-w>p<Cmd>NERDTreeFind<CR>', desc = '[T]ree: [F]ocus File' },
  },
  init = function()
    -- Ignore `.pyc` (Python), `.rbc` (Rubinius), and swap files by default:
    vim.g.NERDTreeIgnore = { '.pyc$', '.rbc$', '~$' }
  end,
  config = function()
    -- Quit Neovim if only buffer open is a NERDTree
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('nerdtree-quit-neovim-if-last-buffer-standing', { clear = true }),
      callback = function()
        if vim.fn.winnr '$' == 1 and vim.b.NERDTreeType == 'primary' then
          vim.cmd 'q'
        end
      end,
    })

    -- This function ensures that the NERDTree is open and the current working
    -- directory is set correctly, whether Vim was opened with no arguments or a
    -- single directory as the first argument.

    local function replace_nerdtree_if_directory()
      local argc = vim.fn.argc()
      local first_arg = argc > 0 and vim.fn.argv(0) or nil
      -- `first_arg` should be a string, but Lua doesn't know that
      if type(first_arg) == 'table' then
        first_arg = first_arg[1]
      end
      local is_dir = first_arg and vim.fn.isdirectory(first_arg) == 1

      if argc == 0 or (first_arg ~= nil and is_dir) then
        -- If the first argument is a directory...
        if first_arg ~= nil and is_dir then
          -- Change the working directory to the first argument
          vim.cmd.cd(vim.fn.fnameescape(first_arg))
          -- At this point, the only buffer open is a NERDTree that is pointing to
          -- that directory. Replace that with an empty buffer.
          vim.cmd.enew()
        end
        -- Ensure that the NERDTree is open.
        vim.cmd.NERDTree()
      end
    end

    -- Don't load netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('nerdtree-hijack-netrw', { clear = true }),
      callback = replace_nerdtree_if_directory,
    })
  end,
}
