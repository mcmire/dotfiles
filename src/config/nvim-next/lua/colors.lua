-- ******************************
-- Colors
-- ******************************

-- This file was largely copied from:
-- <https://github.com/tinted-theming/tinted-nvim/blob/930d1ba963f5224c20dba665fdf81ceded8c2745/lua/tinted-highlighter.lua>

-- Source: <https://github.com/neovim/neovim/issues/32116>
local this_file_path = debug.getinfo(1, 'S').source:sub(2)

-- Test truecolor support
local function vim_color_test(outfile, fgend, bgend)
  local result = {}
  for fg = 0, fgend - 1 do
    for bg = 0, bgend - 1 do
      local kw = string.format('%-7s', string.format('c_%d_%d', fg, bg))
      local h = string.format('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
      local s = string.format('syn keyword %s %s', kw, kw)
      table.insert(result, string.format('%-32s | %s', h, s))
    end
  end
  vim.fn.writefile(result, outfile)
  vim.cmd('edit ' .. outfile)
  vim.cmd 'source %'
end
vim.api.nvim_create_user_command('VimColorTest', function()
  vim_color_test('/tmp/vim-color-test.tmp', 16, 16)
end, {})

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

local M = {}

M.highlight = setmetatable({}, {
  __newindex = function(_, hlgroup, args)
    if 'string' == type(args) then
      vim.api.nvim_set_hl(0, hlgroup, { link = args })
      return
    end

    local guifg, guibg, gui, guisp = args.guifg or nil, args.guibg or nil, args.gui or nil, args.guisp or nil
    local ctermfg, ctermbg = args.ctermfg or nil, args.ctermbg or nil
    local val = {}
    if guifg then
      val.fg = guifg
    end
    if guibg then
      val.bg = guibg
    end
    if ctermfg then
      val.ctermfg = ctermfg
    end
    if ctermbg then
      val.ctermbg = ctermbg
    end
    if guisp then
      val.sp = guisp
    end
    if gui then
      for x in string.gmatch(gui, '([^,]+)') do
        if x ~= 'none' then
          val[x] = true
        end
      end
    end
    if tablelength(val) == 0 then
      print("WARNING: Highlight group '" .. hlgroup .. "' would be cleared accidentally. args = " .. vim.inspect(args))
    else
      vim.api.nvim_set_hl(0, hlgroup, val)
    end
  end,
})

local function get_bright(_key)
  return nil
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

-- This list was derived by reverse-engineering the colors below.
--
-- See :h cterm
-- and also <https://github.com/tinted-theming/home/blob/main/styling.md>
-- and <https://github.com/tinted-theming/base24/blob/main/styling.md>
--
-- There are two sets of data we are trying to coalesce here:
--
-- 1. Tinted
--
-- | 0X | Color (base16)           | ANSI (base16) | Color (base24)     | ANSI (base24) |
-- |----|--------------------------|---------------|--------------------|---------------|
-- | 00 | Black                    | 0             | Background         | 0             |
-- | 01 | (Darkest Gray)           | 18            | (Darkest Gray)     | 18            |
-- | 02 | (Dark Gray)              | 19            | Bright Black       | 19            |
-- | 03 | Bright Black / Gray      | 8             | (Gray)             | 8             |
-- | 04 | (Light Gray)             | 20            | (Light Gray)       | 20            |
-- | 05 | White                    | 7             | Foreground         | 21            |
-- | 06 | (Lighter White)          | 21            | (White)            | 7             |
-- | 07 | Bright White             | 15            | Bright White       | 15            |
-- | 08 | Red / Bright Red         | 1 / 9         | Red                | 1             |
-- | 09 | (Orange)                 | 16            | (Orange)           | 16            |
-- | OA | Yellow / Bright Yellow   | 3 / 11        | Yellow             | 3             |
-- | OB | Green / Bright Green     | 2 / 10        | Green              | 2             |
-- | OC | Cyan / Bright Cyan       | 6 / 14        | Cyan               | 6             |
-- | OD | Blue / Bright Blue       | 4 / 12        | Blue               | 4             |
-- | OE | Magenta / Bright Magenta | 5 / 13        | Magenta            | 5             |
-- | OF | (Dark Red / Brown)       | 17            | (Dark Red / Brown) | 17            |
-- | 10 | -                        | -             | (Darker Black)     | -             |
-- | 11 | -                        | -             | (Darkest Black)    | -             |
-- | 12 | -                        | -             | Bright Red         | 9             |
-- | 13 | -                        | -             | Bright Yellow      | 11            |
-- | 14 | -                        | -             | Bright Green       | 10            |
-- | 15 | -                        | -             | Bright Cyan        | 14            |
-- | 16 | -                        | -             | Bright Blue        | 12            |
-- | 17 | -                        | -             | Bright Magenta     | 13            |
--
-- 2. cterm values
--
-- | Color Name              | # (8 colors) | # (16 colors) |
-- | Black                   | 0            | 0             |
-- | Dark Blue               | 4            | 1             |
-- | Dark Green              | 2            | 2             |
-- | Dark Cyan               | 6            | 3             |
-- | Dark Red                | 1            | 4             |
-- | Dark Magenta            | 5            | 5             |
-- | Brown / Dark Yellow     | 3            | 6             |
-- | Light Gray / Grey       | 7            | 7             |
-- | Dark Gray               | 0*           | 8             |
-- | Blue / Light Blue       | 4*           | 9             |
-- | Green / Light Green     | 2*           | 10            |
-- | Cyan / Light Cyan       | 6*           | 11            |
-- | Red / Light Red         | 1*           | 12            |
-- | Magenta / Light Magenta | 5*           | 13            |
-- | Yellow / Light Yellow   | 3*           | 14            |
-- | White                   | 7*           | 15            |
--
M.colors = {
  cterm00 = 0, -- Background
  cterm01 = 0, -- Darkest Gray
  cterm02 = 7, -- Bright Black
  cterm03 = 7, -- Gray
  cterm04 = 8, -- Light Gray (0 + bold?)
  cterm05 = 8, -- Foreground (0 + bold?)
  cterm06 = 15, -- White (7 + bold?)
  cterm07 = 15, -- Bright White (7 + bold?)
  cterm08 = 1, -- Red
  cterm09 = 3, -- Orange
  cterm10 = 8, -- Bright Black
  cterm0A = 3, -- Yellow
  cterm0B = 2, -- Green
  cterm0C = 6, -- Cyan
  cterm0D = 4, -- Blue
  cterm0E = 5, -- Magenta
  cterm0F = 1, -- Dark Red / Brown
  cterm12 = 9, -- Bright Red (1 + bold?)
  cterm13 = 11, -- Bright Yellow (3 + bold?)
  cterm14 = 10, -- Bright Green (2 + bold?)
  cterm15 = 14, -- Bright Cyan (6 + bold?)
  cterm16 = 12, -- Bright Blue (4 + bold?)
  cterm17 = 13, -- Bright Magenta (5 + bold?)
}

local hi = M.highlight

-- Vim editor colors
hi.Normal = {
  guifg = M.colors.base05,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm00,
}
--[[
hi.Bold = { guifg = nil, guibg = nil, gui = 'bold', guisp = nil, ctermfg = nil, ctermbg = nil }
hi.Debug = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.Directory = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.Error = {
  guifg = M.colors.base08,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm08,
  ctermbg = M.colors.cterm00,
}
hi.ErrorMsg = {
  guifg = M.colors.base08,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm08,
  ctermbg = M.colors.cterm00,
}
hi.Exception = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.FoldColumn = {
  guifg = M.colors.base0C,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0C,
  ctermbg = M.colors.cterm00,
}
hi.Folded = {
  guifg = M.colors.base03,
  guibg = M.colors.base01,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm03,
  ctermbg = M.colors.cterm01,
}
hi.IncSearch = {
  guifg = M.colors.base01,
  guibg = M.colors.base09,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm01,
  ctermbg = M.colors.cterm09,
}
hi.Italic = { guifg = nil, guibg = nil, gui = 'italic', guisp = nil, ctermfg = nil, ctermbg = nil }
hi.Macro = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.MatchParen = {
  guifg = nil,
  guibg = M.colors.base03,
  gui = nil,
  guisp = nil,
  ctermfg = nil,
  ctermbg = M.colors.cterm03,
}
hi.ModeMsg = { guifg = M.colors.base0B, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
hi.MoreMsg = { guifg = M.colors.base0B, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
hi.Question = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.Search = {
  guifg = M.colors.base01,
  guibg = M.colors.base0A,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm01,
  ctermbg = M.colors.cterm0A,
}
hi.Substitute = {
  guifg = M.colors.base01,
  guibg = M.colors.base0A,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm01,
  ctermbg = M.colors.cterm0A,
}
hi.SpecialKey = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
hi.TooLong = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.Underlined = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.Visual = { guifg = nil, guibg = M.colors.base02, gui = nil, guisp = nil, ctermfg = nil, ctermbg = M.colors.cterm02 }
hi.VisualNOS = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.WarningMsg = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.WildMenu = {
  guifg = M.colors.base08,
  guibg = M.colors.base0A,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm08,
  ctermbg = M.colors.cterm0A,
}
hi.Title = { guifg = get_bright 'base0D', guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.Conceal = {
  guifg = M.colors.base0D,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0D,
  ctermbg = M.colors.cterm00,
}
hi.Cursor = {
  guifg = M.colors.base00,
  guibg = M.colors.base05,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm00,
  ctermbg = M.colors.cterm05,
}
hi.NonText = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
hi.LineNr = {
  guifg = M.colors.base04,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm04,
  ctermbg = M.colors.cterm00,
}
hi.SignColumn = {
  guifg = M.colors.base04,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm04,
  ctermbg = M.colors.cterm00,
}
hi.StatusLine = {
  guifg = M.colors.base05,
  guibg = M.colors.base02,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm02,
}
hi.StatusLineNC = {
  guifg = M.colors.base04,
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm04,
  ctermbg = M.colors.cterm01,
}
hi.WinBar = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
hi.WinBarNC = { guifg = M.colors.base04, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm04, ctermbg = nil }
hi.VertSplit = {
  guifg = M.colors.base05,
  guibg = M.colors.base00,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm00,
}
hi.ColorColumn = {
  guifg = nil,
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = nil,
  ctermbg = M.colors.cterm01,
}
hi.CursorColumn = {
  guifg = nil,
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = nil,
  ctermbg = M.colors.cterm01,
}
hi.CursorLine = {
  guifg = nil,
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = nil,
  ctermbg = M.colors.cterm01,
}
hi.CursorLineNr = {
  guifg = get_bright 'base04',
  guibg = M.colors.base01,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm04,
  ctermbg = M.colors.cterm01,
}
hi.QuickFixLine = {
  guifg = nil,
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = nil,
  ctermbg = M.colors.cterm01,
}
hi.PMenu = {
  guifg = M.colors.base05,
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm01,
}
hi.PMenuSel = {
  guifg = M.colors.base01,
  guibg = M.colors.base05,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm01,
  ctermbg = M.colors.cterm05,
}
hi.TabLine = {
  guifg = M.colors.base03,
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm03,
  ctermbg = M.colors.cterm01,
}
hi.TabLineFill = {
  guifg = M.colors.base03,
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm03,
  ctermbg = M.colors.cterm01,
}
hi.TabLineSel = {
  guifg = M.colors.base0B,
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm0B,
  ctermbg = M.colors.cterm01,
}
]]

-- Standard syntax highlighting
hi.Boolean = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
--[[
hi.Character = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.Comment = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
hi.Conditional = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.Constant = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.Define = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.Delimiter = { guifg = M.colors.base0F, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
hi.Float = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.Function = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.Identifier = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.Include = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.Keyword = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.Label = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.Number = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.Operator = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.PreProc = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.Repeat = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.Special = { guifg = M.colors.base0C, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
hi.SpecialChar = { guifg = M.colors.base0F, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
hi.Statement = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.StorageClass = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.String = { guifg = M.colors.base0B, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
hi.Structure = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.Tag = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.Todo = {
  guifg = M.colors.base0A,
  guibg = M.colors.base01,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0A,
  ctermbg = M.colors.cterm01,
}
hi.Type = { guifg = M.colors.base0A, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.Typedef = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
]]

-- Diff highlighting
hi.DiffAdd = {
  guifg = M.colors.base0B,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0B,
  ctermbg = M.colors.cterm00,
}
hi.DiffChange = {
  guifg = M.colors.base0E,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm03,
  ctermbg = M.colors.cterm00,
}
hi.DiffDelete = {
  guifg = M.colors.base08,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm08,
  ctermbg = M.colors.cterm00,
}
hi.DiffText = {
  guifg = M.colors.base0D,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0D,
  ctermbg = M.colors.cterm00,
}
hi.DiffAdded = {
  guifg = M.colors.base0B,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0B,
  ctermbg = M.colors.cterm00,
}
hi.DiffFile = {
  guifg = M.colors.base08,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm08,
  ctermbg = M.colors.cterm00,
}
hi.DiffNewFile = {
  guifg = M.colors.base0B,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0B,
  ctermbg = M.colors.cterm00,
}
hi.DiffLine = {
  guifg = M.colors.base0D,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0D,
  ctermbg = M.colors.cterm00,
}
hi.DiffRemoved = {
  guifg = M.colors.base08,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm08,
  ctermbg = M.colors.cterm00,
}

-- Git highlighting
hi.gitcommitOverflow = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.gitcommitSummary = { guifg = M.colors.base0B, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
hi.gitcommitComment = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
hi.gitcommitUntracked = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
hi.gitcommitDiscarded = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
hi.gitcommitSelected = { guifg = M.colors.base03, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
hi.gitcommitHeader = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.gitcommitSelectedType = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.gitcommitUnmergedType = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.gitcommitDiscardedType = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.gitcommitBranch = { guifg = M.colors.base09, guibg = nil, gui = 'bold', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.gitcommitUntrackedFile = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.gitcommitUnmergedFile = { guifg = M.colors.base08, guibg = nil, gui = 'bold', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.gitcommitDiscardedFile = {
  guifg = M.colors.base08,
  guibg = nil,
  gui = 'bold',
  guisp = nil,
  ctermfg = M.colors.cterm08,
  ctermbg = nil,
}
hi.gitcommitSelectedFile = { guifg = M.colors.base0B, guibg = nil, gui = 'bold', guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }

-- GitGutter highlighting
hi.GitGutterAdd = {
  guifg = M.colors.base0B,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0B,
  ctermbg = M.colors.cterm00,
}
hi.GitGutterChange = {
  guifg = M.colors.base0E,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0D,
  ctermbg = M.colors.cterm00,
}
hi.GitGutterDelete = {
  guifg = M.colors.base08,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm08,
  ctermbg = M.colors.cterm00,
}
hi.GitGutterChangeDelete = {
  guifg = M.colors.base09,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm0E,
  ctermbg = M.colors.cterm00,
}

-- Spelling highlighting
hi.SpellBad = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base08, ctermfg = nil, ctermbg = nil }
hi.SpellLocal = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base0C, ctermfg = nil, ctermbg = nil }
hi.SpellCap = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base0D, ctermfg = nil, ctermbg = nil }
hi.SpellRare = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = M.colors.base0E, ctermfg = nil, ctermbg = nil }

hi.DiagnosticError = { guifg = get_bright 'base08', guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.DiagnosticWarn = { guifg = get_bright 'base09', guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.DiagnosticInfo = { guifg = get_bright 'base0D', guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.DiagnosticHint = { guifg = get_bright 'base0C', guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
hi.DiagnosticUnderlineError = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = get_bright 'base08', ctermfg = nil, ctermbg = nil }
hi.DiagnosticUnderlineWarn = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = get_bright 'base09', ctermfg = nil, ctermbg = nil }
hi.DiagnosticUnderlineInfo = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = get_bright 'base0D', ctermfg = nil, ctermbg = nil }
hi.DiagnosticUnderlineHint = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = get_bright 'base0C', ctermfg = nil, ctermbg = nil }
if vim.fn.has 'nvim-0.9.0' == 1 then
  hi.DiagnosticOk = { guifg = get_bright 'base0B', guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
  hi.DiagnosticUnderlineOk = { guifg = nil, guibg = nil, gui = 'undercurl', guisp = get_bright 'base0B', ctermfg = nil, ctermbg = nil }
end

hi.LspReferenceText = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
hi.LspReferenceRead = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
hi.LspReferenceWrite = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }

if vim.fn.has 'nvim-0.6.0' == 0 then
  hi.LspDiagnosticsDefaultError = 'DiagnosticError'
  hi.LspDiagnosticsDefaultWarning = 'DiagnosticWarn'
  hi.LspDiagnosticsDefaultInformation = 'DiagnosticInfo'
  hi.LspDiagnosticsDefaultHint = 'DiagnosticHint'
  hi.LspDiagnosticsUnderlineError = 'DiagnosticUnderlineError'
  hi.LspDiagnosticsUnderlineWarning = 'DiagnosticUnderlineWarn'
  hi.LspDiagnosticsUnderlineInformation = 'DiagnosticUnderlineInfo'
  hi.LspDiagnosticsUnderlineHint = 'DiagnosticUnderlineHint'
end

hi.TSAnnotation = { guifg = M.colors.base0F, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
hi.TSAttribute = { guifg = M.colors.base0A, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.TSBoolean = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.TSCharacter = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.TSComment = { guifg = M.colors.base03, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
hi.TSConstructor = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.TSConditional = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.TSConstant = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.TSConstBuiltin = { guifg = M.colors.base09, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.TSConstMacro = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.TSError = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.TSException = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.TSField = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
hi.TSFloat = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.TSFunction = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.TSFuncBuiltin = { guifg = M.colors.base0D, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.TSFuncMacro = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.TSInclude = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.TSKeyword = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.TSKeywordFunction = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.TSKeywordOperator = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.TSLabel = { guifg = M.colors.base0A, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.TSMethod = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.TSNamespace = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.TSNone = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
hi.TSNumber = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.TSOperator = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
hi.TSParameter = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
hi.TSParameterReference = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
hi.TSProperty = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
hi.TSPunctDelimiter = { guifg = M.colors.base0F, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
hi.TSPunctBracket = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
hi.TSPunctSpecial = { guifg = M.colors.base0F, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
hi.TSRepeat = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
hi.TSString = { guifg = M.colors.base0B, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
hi.TSStringRegex = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
hi.TSStringEscape = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
hi.TSSymbol = { guifg = M.colors.base0B, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0B, ctermbg = nil }
hi.TSTag = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.TSTagDelimiter = { guifg = M.colors.base0F, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0F, ctermbg = nil }
hi.TSText = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
hi.TSStrong = { guifg = nil, guibg = nil, gui = 'bold', guisp = nil, ctermfg = nil, ctermbg = nil, cterm = 'bold' }
hi.TSEmphasis = { guifg = nil, guibg = nil, gui = 'italic', guisp = nil, ctermfg = nil, ctermbg = nil, cterm = 'italic' }
hi.TSUnderline = {
  guifg = nil,
  guibg = nil,
  gui = 'underline',
  guisp = nil,
  ctermfg = nil,
  ctermbg = nil,
  cterm = 'underline',
}
hi.TSStrike = {
  guifg = nil,
  guibg = nil,
  gui = 'strikethrough',
  guisp = nil,
  ctermfg = nil,
  ctermbg = nil,
  cterm = 'strikethrough',
}
hi.TSTitle = { guifg = M.colors.base0D, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
hi.TSLiteral = { guifg = M.colors.base09, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.TSURI = { guifg = M.colors.base09, guibg = nil, gui = 'underline', guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
hi.TSType = { guifg = M.colors.base0A, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.TSTypeBuiltin = { guifg = M.colors.base0A, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
hi.TSVariable = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
hi.TSVariableBuiltin = { guifg = M.colors.base08, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }

hi.TSDefinition = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
hi.TSDefinitionUsage = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
hi.TSCurrentScope = { guifg = nil, guibg = nil, gui = 'bold', guisp = nil, ctermfg = nil, ctermbg = nil }

hi.LspInlayHint = { guifg = M.colors.base03, guibg = nil, gui = 'italic', guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }

--[[
if vim.fn.has 'nvim-0.8.0' then
  hi['@comment'] = 'TSComment'
  hi['@error'] = 'TSError'
  hi['@none'] = 'TSNone'
  hi['@preproc'] = 'PreProc'
  hi['@define'] = 'Define'
  hi['@operator'] = 'TSOperator'
  hi['@punctuation.delimiter'] = 'TSPunctDelimiter'
  hi['@punctuation.bracket'] = 'TSPunctBracket'
  hi['@punctuation.special'] = 'TSPunctSpecial'
  hi['@string'] = 'TSString'
  hi['@string.regex'] = 'TSStringRegex'
  hi['@string.escape'] = 'TSStringEscape'
  hi['@string.special'] = 'SpecialChar'
  hi['@character'] = 'TSCharacter'
  hi['@character.special'] = 'SpecialChar'
  hi['@boolean'] = 'TSBoolean'
  hi['@number'] = 'TSNumber'
  hi['@float'] = 'TSFloat'
  hi['@function'] = 'TSFunction'
  hi['@function.call'] = 'TSFunction'
  hi['@function.builtin'] = 'TSFuncBuiltin'
  hi['@function.macro'] = 'TSFuncMacro'
  hi['@method'] = 'TSMethod'
  hi['@method.call'] = 'TSMethod'
  hi['@constructor'] = 'TSConstructor'
  hi['@parameter'] = 'TSParameter'
  hi['@keyword'] = 'TSKeyword'
  hi['@keyword.function'] = 'TSKeywordFunction'
  hi['@keyword.operator'] = 'TSKeywordOperator'
  hi['@keyword.return'] = 'TSKeyword'
  hi['@conditional'] = 'TSConditional'
  hi['@repeat'] = 'TSRepeat'
  hi['@debug'] = 'Debug'
  hi['@label'] = 'TSLabel'
  hi['@include'] = 'TSInclude'
  hi['@exception'] = 'TSException'
  hi['@type'] = 'TSType'
  hi['@type.builtin'] = 'TSTypeBuiltin'
  hi['@type.qualifier'] = 'TSKeyword'
  hi['@type.definition'] = 'TSType'
  hi['@storageclass'] = 'StorageClass'
  hi['@attribute'] = 'TSAttribute'
  hi['@field'] = 'TSField'
  hi['@property'] = 'TSProperty'
  hi['@variable'] = 'TSVariable'
  hi['@variable.builtin'] = 'TSVariableBuiltin'
  hi['@constant'] = 'TSConstant'
  hi['@constant.builtin'] = 'TSConstant'
  hi['@constant.macro'] = 'TSConstant'
  hi['@namespace'] = 'TSNamespace'
  hi['@symbol'] = 'TSSymbol'
  hi['@text'] = 'TSText'
  hi['@text.diff.add'] = 'DiffAdd'
  hi['@text.diff.delete'] = 'DiffDelete'
  hi['@text.strong'] = 'TSStrong'
  hi['@text.emphasis'] = 'TSEmphasis'
  hi['@text.underline'] = 'TSUnderline'
  hi['@text.strikethrough'] = 'TSStrike'
  hi['@text.title'] = 'TSTitle'
  hi['@text.literal'] = 'TSLiteral'
  hi['@text.uri'] = 'TSUri'
  hi['@text.math'] = 'Number'
  hi['@text.environment'] = 'Macro'
  hi['@text.environment.name'] = 'Type'
  hi['@text.reference'] = 'TSParameterReference'
  hi['@text.todo'] = 'Todo'
  hi['@text.note'] = 'Tag'
  hi['@text.warning'] = 'DiagnosticWarn'
  hi['@text.danger'] = 'DiagnosticError'
  hi['@tag'] = 'TSTag'
  hi['@tag.attribute'] = 'TSAttribute'
  hi['@tag.delimiter'] = 'TSTagDelimiter'

  hi['@function.method'] = '@method'
  hi['@function.method.call'] = '@method.call'
  hi['@comment.error'] = '@text.danger'
  hi['@comment.warning'] = '@text.warning'
  hi['@comment.hint'] = 'DiagnosticHint'
  hi['@comment.info'] = 'DiagnosticInfo'
  hi['@comment.todo'] = '@text.todo'
  hi['@diff.plus'] = '@text.diff.add'
  hi['@diff.minus'] = '@text.diff.delete'
  hi['@diff.delta'] = 'DiffChange'
  hi['@string.special.url'] = '@text.uri'
  hi['@keyword.directive'] = '@preproc'
  hi['@keyword.directive.define'] = '@define'
  hi['@keyword.storage'] = '@storageclass'
  hi['@keyword.conditional'] = '@conditional'
  hi['@keyword.debug'] = '@debug'
  hi['@keyword.exception'] = '@exception'
  hi['@keyword.import'] = '@include'
  hi['@keyword.repeat'] = '@repeat'
  hi['@variable.parameter'] = '@parameter'
  hi['@variable.member'] = '@field'
  hi['@module'] = '@namespace'
  hi['@number.float'] = '@float'
  hi['@string.special.symbol'] = '@symbol'
  hi['@string.regexp'] = '@string.regex'
  hi['@markup.strong'] = '@text.strong'
  hi['@markup.italic'] = 'Italic'
  hi['@markup.link'] = '@text.link'
  hi['@markup.strikethrough'] = '@text.strikethrough'
  hi['@markup.heading'] = '@text.title'
  hi['@markup.raw'] = '@text.literal'
  hi['@markup.link'] = '@text.reference'
  hi['@markup.link.url'] = '@text.uri'
  hi['@markup.link.label'] = '@string.special'
  hi['@markup.list'] = '@punctuation.special'
end
]]

--[[
if highlights.ts_rainbow then
  hi.rainbowcol1 = { guifg = get_bright 'base06', ctermfg = M.colors.cterm06 }
  hi.rainbowcol2 = { guifg = get_bright 'base09', ctermfg = M.colors.cterm09 }
  hi.rainbowcol3 = { guifg = get_bright 'base0A', ctermfg = M.colors.cterm0A }
  hi.rainbowcol4 = { guifg = get_bright 'base07', ctermfg = M.colors.cterm07 }
  hi.rainbowcol5 = { guifg = get_bright 'base0C', ctermfg = M.colors.cterm0C }
  hi.rainbowcol6 = { guifg = get_bright 'base0D', ctermfg = M.colors.cterm0D }
  hi.rainbowcol7 = { guifg = get_bright 'base0E', ctermfg = M.colors.cterm0E }
end
]]

hi.NvimInternalError = {
  guifg = M.colors.base00,
  guibg = M.colors.base08,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm00,
  ctermbg = M.colors.cterm08,
}

hi.NormalFloat = {
  guifg = M.colors.base05,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm00,
}
hi.FloatBorder = {
  guifg = M.colors.base05,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm00,
}
hi.NormalNC = {
  guifg = M.colors.base05,
  guibg = M.colors.base00,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm00,
}
hi.TermCursor = {
  guifg = M.colors.base00,
  guibg = M.colors.base05,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm00,
  ctermbg = M.colors.cterm05,
}
hi.TermCursorNC = {
  guifg = M.colors.base00,
  guibg = M.colors.base05,
  gui = nil,
  guisp = nil,
  ctermfg = M.colors.cterm00,
  ctermbg = M.colors.cterm05,
}

hi.User1 = {
  guifg = get_bright 'base08',
  guibg = M.colors.base02,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm08,
  ctermbg = M.colors.cterm02,
}
hi.User2 = {
  guifg = get_bright 'base09',
  guibg = M.colors.base02,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm0E,
  ctermbg = M.colors.cterm02,
}
hi.User3 = {
  guifg = get_bright 'base0B',
  guibg = M.colors.base02,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm02,
}
hi.User4 = {
  guifg = get_bright 'base0C',
  guibg = M.colors.base02,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm0C,
  ctermbg = M.colors.cterm02,
}
hi.User5 = {
  guifg = get_bright 'base0D',
  guibg = M.colors.base02,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm02,
}
hi.User6 = {
  guifg = get_bright 'base0E',
  guibg = M.colors.base01,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm01,
}
hi.User7 = {
  guifg = M.colors.base05,
  guibg = M.colors.base02,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm05,
  ctermbg = M.colors.cterm02,
}
hi.User8 = {
  guifg = M.colors.base00,
  guibg = M.colors.base02,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm00,
  ctermbg = M.colors.cterm02,
}
hi.User9 = {
  guifg = M.colors.base00,
  guibg = M.colors.base02,
  gui = 'none',
  guisp = nil,
  ctermfg = M.colors.cterm00,
  ctermbg = M.colors.cterm02,
}

hi.TreesitterContext = {
  guifg = nil,
  guibg = M.colors.base01,
  gui = 'italic',
  guisp = nil,
  ctermfg = nil,
  ctermbg = M.colors.cterm01,
}

--[[
if highlights.telescope then
  if not highlights.telescope_borders and hex_re:match_str(M.colors.base00) and hex_re:match_str(M.colors.base01) and hex_re:match_str(M.colors.base02) then
    local darkerbg = darken(M.colors.base00, 0.1)
    local darkercursorline = darken(M.colors.base01, 0.1)
    local darkerstatusline = darken(M.colors.base02, 0.1)
    hi.TelescopeBorder = { guifg = darkerbg, guibg = darkerbg, gui = nil, guisp = nil }
    hi.TelescopePromptBorder = { guifg = darkerstatusline, guibg = darkerstatusline, gui = nil, guisp = nil }
    hi.TelescopePromptNormal = { guifg = M.colors.base05, guibg = darkerstatusline, gui = nil, guisp = nil }
    hi.TelescopePromptPrefix = { guifg = M.colors.base08, guibg = darkerstatusline, gui = nil, guisp = nil }
    hi.TelescopeNormal = { guifg = nil, guibg = darkerbg, gui = nil, guisp = nil }
    hi.TelescopePreviewTitle = { guifg = darkercursorline, guibg = get_bright 'base0B', gui = nil, guisp = nil }
    hi.TelescopePromptTitle = { guifg = darkercursorline, guibg = M.colors.base08, gui = nil, guisp = nil }
    hi.TelescopeResultsTitle = { guifg = darkerbg, guibg = darkerbg, gui = nil, guisp = nil }
    hi.TelescopeSelection = { guifg = nil, guibg = darkerstatusline, gui = nil, guisp = nil }
    hi.TelescopePreviewLine = { guifg = nil, guibg = M.colors.base01, gui = 'none', guisp = nil }
  else
    hi.TelescopeBorder = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
    hi.TelescopePromptBorder = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
    hi.TelescopePromptNormal = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
    hi.TelescopePromptPrefix = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
    hi.TelescopeNormal = { guifg = nil, guibg = M.colors.base00, gui = nil, guisp = nil }
    hi.TelescopePreviewTitle = { guifg = M.colors.base01, guibg = get_bright 'base0B', gui = nil, guisp = nil }
    hi.TelescopePromptTitle = { guifg = M.colors.base01, guibg = M.colors.base08, gui = nil, guisp = nil }
    hi.TelescopeResultsTitle = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil }
    hi.TelescopeSelection = { guifg = nil, guibg = M.colors.base01, gui = nil, guisp = nil }
    hi.TelescopePreviewLine = { guifg = nil, guibg = M.colors.base01, gui = 'none', guisp = nil }
  end
end
]]

--[[
if highlights.notify then
  hi.NotifyERRORBorder = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
  hi.NotifyWARNBorder = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
  hi.NotifyINFOBorder = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
  hi.NotifyDEBUGBorder = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
  hi.NotifyTRACEBorder = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
  hi.NotifyERRORIcon = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
  hi.NotifyWARNIcon = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
  hi.NotifyINFOIcon = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
  hi.NotifyDEBUGIcon = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
  hi.NotifyTRACEIcon = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
  hi.NotifyERRORTitle = { guifg = M.colors.base08, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
  hi.NotifyWARNTitle = { guifg = M.colors.base0E, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
  hi.NotifyINFOTitle = { guifg = M.colors.base05, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
  hi.NotifyDEBUGTitle = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
  hi.NotifyTRACETitle = { guifg = M.colors.base0C, guibg = nil, gui = 'none', guisp = nil, ctermfg = M.colors.cterm0C, ctermbg = nil }
  hi.NotifyERRORBody = 'Normal'
  hi.NotifyWARNBody = 'Normal'
  hi.NotifyINFOBody = 'Normal'
  hi.NotifyDEBUGBody = 'Normal'
  hi.NotifyTRACEBody = 'Normal'
end
]]

--[[
if highlights.indentblankline then
  hi.IndentBlanklineChar = { guifg = M.colors.base02, gui = 'nocombine', ctermfg = M.colors.cterm02 }
  hi.IndentBlanklineContextChar = { guifg = M.colors.base04, gui = 'nocombine', ctermfg = M.colors.cterm04 }
  hi.IblIndent = { guifg = M.colors.base02, gui = 'nocombine', ctermfg = M.colors.cterm02 }
  hi.IblWhitespace = 'Whitespace'
  hi.IblScope = { guifg = M.colors.base04, gui = 'nocombine', ctermfg = M.colors.cterm04 }
end
]]

--[[
if highlights.cmp then
  hi.CmpDocumentationBorder =
    { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
  hi.CmpDocumentation = { guifg = M.colors.base05, guibg = M.colors.base00, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm00 }
  hi.CmpItemAbbr = { guifg = M.colors.base05, guibg = M.colors.base01, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = M.colors.cterm01 }
  hi.CmpItemAbbrDeprecated = { guifg = M.colors.base03, guibg = nil, gui = 'strikethrough', guisp = nil, ctermfg = M.colors.cterm03, ctermbg = nil }
  hi.CmpItemAbbrMatch = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
  hi.CmpItemAbbrMatchFuzzy = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
  hi.CmpItemKindDefault = { guifg = M.colors.base05, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
  hi.CmpItemMenu = { guifg = M.colors.base04, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm04, ctermbg = nil }
  hi.CmpItemKindKeyword = { guifg = M.colors.base0E, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0E, ctermbg = nil }
  hi.CmpItemKindVariable = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
  hi.CmpItemKindConstant = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
  hi.CmpItemKindReference = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
  hi.CmpItemKindValue = { guifg = M.colors.base09, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm09, ctermbg = nil }
  hi.CmpItemKindFunction = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
  hi.CmpItemKindMethod = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
  hi.CmpItemKindConstructor = { guifg = M.colors.base0D, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0D, ctermbg = nil }
  hi.CmpItemKindClass = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
  hi.CmpItemKindInterface = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
  hi.CmpItemKindStruct = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
  hi.CmpItemKindEvent = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
  hi.CmpItemKindEnum = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
  hi.CmpItemKindUnit = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
  hi.CmpItemKindModule = { guifg = M.colors.base05, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
  hi.CmpItemKindProperty = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
  hi.CmpItemKindField = { guifg = M.colors.base08, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm08, ctermbg = nil }
  hi.CmpItemKindTypeParameter = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
  hi.CmpItemKindEnumMember = { guifg = M.colors.base0A, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm0A, ctermbg = nil }
  hi.CmpItemKindOperator = { guifg = M.colors.base05, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm05, ctermbg = nil }
  hi.CmpItemKindSnippet = { guifg = M.colors.base04, guibg = nil, gui = nil, guisp = nil, ctermfg = M.colors.cterm04, ctermbg = nil }
end
]]

--[[
if highlights.illuminate then
  hi.IlluminatedWordText = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
  hi.IlluminatedWordRead = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
  hi.IlluminatedWordWrite = { guifg = nil, guibg = nil, gui = 'underline', guisp = M.colors.base04, ctermfg = nil, ctermbg = nil }
end
]]

--[[
if highlights.lsp_semantic then
  hi['@class'] = 'TSType'
  hi['@struct'] = 'TSType'
  hi['@enum'] = 'TSType'
  hi['@enumMember'] = 'Constant'
  hi['@event'] = 'Identifier'
  hi['@interface'] = 'Structure'
  hi['@modifier'] = 'Identifier'
  hi['@regexp'] = 'TSStringRegex'
  hi['@typeParameter'] = 'Type'
  hi['@decorator'] = 'Identifier'

  hi['@lsp.type.namespace'] = '@namespace'
  hi['@lsp.type.type'] = '@type'
  hi['@lsp.type.class'] = '@type'
  hi['@lsp.type.enum'] = '@type'
  hi['@lsp.type.interface'] = '@type'
  hi['@lsp.type.struct'] = '@type'
  hi['@lsp.type.parameter'] = '@parameter'
  hi['@lsp.type.variable'] = '@variable'
  hi['@lsp.type.property'] = '@property'
  hi['@lsp.type.enumMember'] = '@constant'
  hi['@lsp.type.function'] = '@function'
  hi['@lsp.type.method'] = '@method'
  hi['@lsp.type.macro'] = '@function.macro'
  hi['@lsp.type.decorator'] = '@function'
end
]]

--[[
if highlights.mini_completion then
  hi.MiniCompletionActiveParameter = 'CursorLine'
end
]]

--[[
if highlights.dapui then
  hi.DapUINormal = 'Normal'
  hi.DapUINormal = 'Normal'
  hi.DapUIVariable = 'Normal'
  hi.DapUIScope = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIType = { guifg = M.colors.base0E, ctermfg = M.colors.cterm0E }
  hi.DapUIValue = 'Normal'
  hi.DapUIModifiedValue = { gui = 'bold', guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIDecoration = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIThread = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
  hi.DapUIStoppedThread = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIFrameName = 'Normal'
  hi.DapUISource = { guifg = M.colors.base0E, ctermfg = M.colors.cterm0E }
  hi.DapUILineNumber = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIFloatNormal = 'NormalFloat'
  hi.DapUIFloatBorder = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIWatchesEmpty = { guifg = M.colors.base08, ctermfg = M.colors.cterm08 }
  hi.DapUIWatchesValue = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
  hi.DapUIWatchesError = { guifg = M.colors.base08, ctermfg = M.colors.cterm08 }
  hi.DapUIBreakpointsPath = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIBreakpointsInfo = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
  hi.DapUIBreakpointsCurrentLine = { gui = 'bold', guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
  hi.DapUIBreakpointsLine = 'DapUILineNumber'
  hi.DapUIBreakpointsDisabledLine = { guifg = M.colors.base02, ctermfg = M.colors.cterm02 }
  hi.DapUICurrentFrameName = 'DapUIBreakpointsCurrentLine'
  hi.DapUIStepOver = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIStepInto = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIStepBack = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIStepOut = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIStop = { guifg = M.colors.base08, ctermfg = M.colors.cterm08 }
  hi.DapUIPlayPause = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
  hi.DapUIRestart = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
  hi.DapUIUnavailable = { guifg = M.colors.base02, ctermfg = M.colors.cterm02 }
  hi.DapUIWinSelect = { gui = 'bold', guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIEndofBuffer = 'EndOfBuffer'
  hi.DapUINormalNC = 'Normal'
  hi.DapUIPlayPauseNC = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
  hi.DapUIRestartNC = { guifg = M.colors.base0B, ctermfg = M.colors.cterm0B }
  hi.DapUIStopNC = { guifg = M.colors.base08, ctermfg = M.colors.cterm08 }
  hi.DapUIUnavailableNC = { guifg = M.colors.base02, ctermfg = M.colors.cterm02 }
  hi.DapUIStepOverNC = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIStepIntoNC = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIStepBackNC = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
  hi.DapUIStepOutNC = { guifg = M.colors.base0D, ctermfg = M.colors.cterm0D }
end
]]
