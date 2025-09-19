-- ******************************
-- Mappings
-- ******************************

-- TODO: Split these up

-- Make it easier to navigate between windows
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move focus to the right window' })

-- Disable default behavior of K (lookup man entry)
vim.keymap.set('n', 'K', '', { desc = '(Do nothing for K)' })

-- Keep selection after indenting or dedenting
-- (`gv` will restore the selection after it disappears)
vim.keymap.set('v', '<', '<gv', { desc = 'Indent and keep selection' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent and keep selection' })

-- Reformat the current paragraph
-- This is useful for Markdown, Git commits, or code comments
vim.keymap.set('n', 'Q', 'gq', { desc = 'Reformat the current paragraph' })

-- Add parity with `C` and `D`
vim.keymap.set('n', 'Y', 'y$', { desc = 'Yank to the end of the line' })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Clear highlight' })

-- Paste within a line, overwriting everything to the end
-- Will retain existing clipboard contents
vim.keymap.set('n', '<Leader>p$', '"_Dp', { desc = 'Paste in line, overwriting rest' })

-- Open a new line and paste into that line
-- Will retain existing clipboard contents
vim.keymap.set('n', '<Leader>po', 'o<Space><Backspace><Esc>p', { desc = 'Open new line and paste into it' })

-- Paste, overwriting the current line
-- Will retain existing clipboard contents
vim.keymap.set('n', '<Leader>pc', '"_ddP', { desc = 'Paste, overwriting current line' })

-- Close current tab
vim.keymap.set('n', '<Leader>tc', '<Cmd>tabc<CR>', { desc = 'Close current tab' })

-- Convert Ruby keys in a hash from symbols to strings and vice versa
vim.keymap.set('v', '<Leader>sym', '<Cmd>s/\\v["\']([^"\']+)["\'] \\=\\> /\\1: /g<CR><Cmd>nohls<CR>', { desc = 'Convert Ruby hash to symbol keys' })
vim.keymap.set('v', '<Leader>str', '<Cmd>s/\\v%(:([^:]+) \\=\\>\\|([^[:space:]:]+): )/\'\\1\\2\' => /g<CR><Cmd>nohls<CR>', { desc = 'Convert Ruby hash to string keys' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('custom-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
