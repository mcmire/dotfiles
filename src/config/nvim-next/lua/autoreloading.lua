-- *********************************
-- Autoreloading (aka magic part 2)
-- *********************************

-- Don't keep periodic snapshots of the current file in the same directory, as
-- they need to be gitignored, and they create annoying "contents in conflict
-- with swap file" messages
vim.o.swapfile = false

-- An alternative to 'swapfile'.
-- Automatically reload current file if modified outside of Neovim.
--
-- Sources:
-- * https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
-- * https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
-- * https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
--
local autoreload_group = vim.api.nvim_create_augroup('custom-autoreload', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Detect file modifications outside of Neovim',
  group = autoreload_group,
  callback = function()
    if not vim.fn.mode():match('^(c|r.?|!|t)$') and vim.fn.getcmdwintype() == '' then
      -- Check to see if file was modified outside of Neovim
      -- and offer user choice if modified
      vim.cmd('checktime')
    end
  end,
})
vim.api.nvim_create_autocmd({ 'FileChangedShellPost' }, {
  desc = 'Inform user when buffer was reloaded automatically',
  group = autoreload_group,
  callback = function()
    vim.fn.echo('File changed on disk. Buffer reloaded.')
  end,
})
