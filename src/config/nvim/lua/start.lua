-- ************
-- Starting Vim
-- ************

-- Bootstrap Lazy
-- Copied from Lazy 11.x
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Start Vim with file tree of current directory when no files passed
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Start Vim with file tree of current directory when no files passed',
  group = vim.api.nvim_create_augroup('custom-ensure-file-tree-on-start', { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd 'silent! edit .'
    end
  end,
})

-- When opening a file, jump to last-known cursor position,
-- except for Git commits
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Jump to last known cursor position',
  group = vim.api.nvim_create_augroup('custom-jump-to-last-known-position', { clear = true }),
  callback = function()
    local last_cursor_position = vim.fn.line '\'"'
    local end_of_document = vim.fn.line '$'
    if vim.o.ft ~= 'gitcommit' and last_cursor_position > 0 and last_cursor_position <= end_of_document then
      vim.cmd.normal 'g`"'
    end
  end,
})

-- Always show line numbers
-- NOTE: Sometimes after Lazy opens, line numbers disappear.
-- We use an autocmd to fix this.
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Ensure line numbers are enabled',
  group = vim.api.nvim_create_augroup('custom-ensure-line-numbers', { clear = true }),
  callback = function()
    vim.o.number = true
  end,
})

-- When we're editing a file, new diagnostics and signs may appear and
-- disappear, and we don't want the sign column popping in and out
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Ensure line numbers are enabled',
  group = vim.api.nvim_create_augroup('custom-ensure-sign-column-visible', { clear = true }),
  callback = function()
    vim.o.signcolumn = 'yes:1'
  end,
})
