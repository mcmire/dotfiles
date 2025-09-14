-- ******************************
-- Line wrapping settings
-- ******************************

-- Disable soft-wrapping by default
vim.o.wrap = false

-- Add mapping for toggling soft-wrapping
vim.keymap.set('n', '<Leader>wi', function()
  vim.o.wrap = not vim.o.wrap
end)

-- When soft-wrapping is enabled, break lines by word boundaries;
-- and distinguish soft-wrapped lines from hard-wrapped ones
-- by indenting and marking them
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = '> '

-- Allow for navigating wrapped lines as though they are real lines
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { remap = false })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { remap = false })

-- Configure hard-wrapping:
-- * Use `textwidth` to wrap lines
-- * Prefix new lines with comment characters
-- * Allow for formatting comments with `gq`
-- * Automatically create a new line as words are typed, but only after space
--   is pressed, and only if the existing line does not exceed `textwidth`
vim.opt.formatoptions:append { r = true, o = true, v = true, b = true }

-- Toggle hard-wrapping
old_textwidth = 0
vim.keymap.set('n', '<Leader>ww', function()
  if vim.o.textwidth > 0 then
    old_textwidth = vim.o.textwidth
    vim.o.textwidth = 0
  else
    vim.o.textwidth = old_textwidth
  end
end)
