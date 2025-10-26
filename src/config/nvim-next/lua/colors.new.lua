-- ******************************
-- Colors
-- ******************************

-- This file was largely copied from:
-- <https://github.com/bjarneo/pixel.nvim>

-- Source: <https://github.com/neovim/neovim/issues/32116>
local this_file_path = debug.getinfo(1, 'S').source:sub(2)

local function hi(group, opts)
  local cmd = 'highlight ' .. group
  if opts.ctermfg then
    cmd = cmd .. ' ctermfg=' .. opts.ctermfg
  end
  if opts.ctermbg then
    cmd = cmd .. ' ctermbg=' .. opts.ctermbg
  end
  if opts.cterm then
    cmd = cmd .. ' cterm=' .. opts.cterm
  end

  vim.cmd(cmd)
end

-- Disable 24-bit color; rely on ANSI colors defined by terminal colorscheme
vim.o.termguicolors = false

-- When we're editing a file, new diagnostics and signs may appear and
-- disappear, and we don't want the sign column popping in and out
vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'Reload color assignments when updated',
  pattern = { this_file_path },
  group = vim.api.nvim_create_augroup('custom-reload-colors', { clear = false }),
  callback = function()
    vim.cmd('source "' .. this_file_path .. '"')
  end,
})

local colors = {
  black = 0,
  red = 1,
  green = 2,
  yellow = 3,
  blue = 4,
  magenta = 5,
  cyan = 6,
  white = 7,
  br_black = 8,
  br_red = 9,
  br_green = 10,
  br_yellow = 11,
  br_blue = 12,
  br_magenta = 13,
  br_cyan = 14,
  br_white = 15,
}

local config = {
  disable_italics = false,
}

-- Basic highlight groups - using only ANSI terminal colors
hi('Normal', { ctermfg = colors.br_white, ctermbg = colors.black })
hi('Cursor', { ctermfg = colors.black, ctermbg = colors.white })
hi('CursorLine', { ctermfg = colors.white, ctermbg = colors.br_black })
hi('CursorColumn', { ctermbg = colors.br_black })
hi('LineNr', { ctermfg = colors.br_black })
hi('CursorLineNr', { ctermfg = colors.white })

-- Syntax highlighting - using ANSI colors for dynamic adaptation
hi('Comment', { ctermfg = colors.white, cterm = config.disable_italics and 'NONE' or 'italic' })
hi('String', { ctermfg = colors.green })
hi('Character', { ctermfg = colors.br_green })
hi('Number', { ctermfg = colors.cyan })
hi('Float', { ctermfg = colors.cyan })
hi('Boolean', { ctermfg = colors.red })
hi('Constant', { ctermfg = colors.magenta })
hi('Identifier', { ctermfg = colors.white })
hi('Function', { ctermfg = colors.red, cterm = 'bold' })
hi('Statement', { ctermfg = colors.blue, cterm = 'bold' })
hi('Conditional', { ctermfg = colors.blue })
hi('Repeat', { ctermfg = colors.blue })
hi('Label', { ctermfg = colors.blue })
hi('Operator', { ctermfg = colors.white })
hi('Keyword', { ctermfg = colors.blue, cterm = 'bold' })
hi('Exception', { ctermfg = colors.red })
hi('PreProc', { ctermfg = colors.br_magenta })
hi('Include', { ctermfg = colors.br_magenta })
hi('Define', { ctermfg = colors.br_magenta })
hi('Macro', { ctermfg = colors.br_magenta })
hi('PreCondit', { ctermfg = colors.br_magenta })
hi('Type', { ctermfg = colors.yellow, cterm = 'bold' })
hi('StorageClass', { ctermfg = colors.yellow })
hi('Structure', { ctermfg = colors.yellow })
hi('Typedef', { ctermfg = colors.yellow })
hi('Special', { ctermfg = colors.cyan })
hi('SpecialChar', { ctermfg = colors.br_cyan })
hi('Tag', { ctermfg = colors.red })
hi('Delimiter', { ctermfg = colors.br_black })
hi('SpecialComment', { ctermfg = colors.br_yellow })
hi('Debug', { ctermfg = colors.br_red })

-- Additional syntax highlighting
hi('Class', { ctermfg = colors.yellow, cterm = 'bold' })
hi('Variable', { ctermfg = colors.white })
hi('Property', { ctermfg = colors.cyan })
hi('Method', { ctermfg = colors.red })

-- UI elements
hi('Visual', { ctermbg = colors.br_black })
hi('Search', { ctermfg = colors.black, ctermbg = colors.yellow, cterm = 'bold' })
hi('IncSearch', { ctermfg = colors.black, ctermbg = colors.br_yellow, cterm = 'bold' })
hi('StatusLine', { ctermfg = colors.white, ctermbg = colors.br_black, cterm = 'bold' })
hi('StatusLineNC', { ctermfg = colors.br_black })
hi('VertSplit', { ctermfg = colors.br_black })
hi('Pmenu', { ctermfg = colors.white, ctermbg = colors.br_black })
hi('PmenuSel', { ctermfg = colors.black, ctermbg = colors.blue, cterm = 'bold' })
hi('PmenuSbar', { ctermbg = colors.br_black })
hi('PmenuThumb', { ctermbg = colors.white })
hi('TabLine', { ctermfg = colors.br_black })
hi('TabLineFill', { ctermfg = colors.br_black })
hi('TabLineSel', { ctermfg = colors.white, ctermbg = colors.br_black, cterm = 'bold' })

-- Diff highlighting
hi('DiffAdd', { ctermfg = colors.green, cterm = 'bold' })
hi('DiffChange', { ctermfg = colors.yellow })
hi('DiffDelete', { ctermfg = colors.red, cterm = 'bold' })
hi('DiffText', { ctermfg = colors.br_yellow, cterm = 'bold' })

-- Error and warning
hi('Error', { ctermfg = colors.br_red, cterm = 'bold' })
hi('Warning', { ctermfg = colors.br_yellow, cterm = 'bold' })
hi('ErrorMsg', { ctermfg = colors.br_red, cterm = 'bold' })
hi('WarningMsg', { ctermfg = colors.br_yellow, cterm = 'bold' })
hi('Question', { ctermfg = colors.green, cterm = 'bold' })
hi('MoreMsg', { ctermfg = colors.green, cterm = 'bold' })

-- Folding
hi('Folded', { ctermfg = colors.br_black, cterm = config.disable_italics and 'NONE' or 'italic' })
hi('FoldColumn', { ctermfg = colors.br_black })

-- Spelling
hi('SpellBad', { ctermfg = colors.red, cterm = 'underline' })
hi('SpellCap', { ctermfg = colors.blue, cterm = 'underline' })
hi('SpellLocal', { ctermfg = colors.cyan, cterm = 'underline' })
hi('SpellRare', { ctermfg = colors.magenta, cterm = 'underline' })

-- Floating windows
hi('NormalFloat', { ctermfg = colors.white, ctermbg = colors.black })
hi('FloatBorder', { ctermfg = colors.br_black, ctermbg = colors.black })
hi('FloatTitle', { ctermfg = colors.blue, ctermbg = colors.black, cterm = 'bold' })

-- File explorer and tree colors
hi('Directory', { ctermfg = colors.blue, cterm = 'bold' })
