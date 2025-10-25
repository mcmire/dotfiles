-- See the following for color variables:
-- <https://github.com/calind/selenized.nvim/blob/8663bf6b222d911e04a9f1b391c3b1ccd22adb69/colors/selenized.lua>

---@class SelenizedColors
---@field bg_0 string
---@field bg_1 string
---@field bg_2 string
---@field bg_15 string
---@field dim_0 string
---@field dim_1 string
---@field fg_0 string
---@field fg_1 string
---@field red string
---@field green string
---@field yellow string
---@field blue string
---@field magenta string
---@field cyan string
---@field orange string
---@field violet string
---@field br_red string
---@field br_green string
---@field br_yellow string
---@field br_blue string
---@field br_magenta string
---@field br_cyan string
---@field br_orange string
---@field br_violet string

---@class Selenized
---@field colors SelenizedColors

---@type Selenized
_G.selenized = _G.selenized or {}

return {
  'calind/selenized.nvim',
  -- Load this before all of the other start plugins.
  priority = 1000,
  config = function()
    -- TODO: Figure out why we need to do this.
    vim.o.background = 'dark'
    vim.cmd 'colorscheme selenized'

    -- Color floats
    vim.cmd('highlight NormalFloat guifg=' .. selenized.colors.fg_0 .. ' guibg=' .. selenized.colors.bg_0)
    -- Color indent lines
    vim.cmd('highlight Whitespace guifg=' .. selenized.colors.bg_2)
    vim.cmd('highlight IndentLine guifg=' .. selenized.colors.bg_2)
    vim.cmd('highlight IndentLineCurrent guifg=' .. selenized.colors.bg_2)
    -- Color neo-tree title bar
    vim.cmd('highlight NeoTreeTitleBar guifg=' .. selenized.colors.bg_0 .. ' guibg=' .. selenized.colors.blue)
    -- Color neo-tree directory
    vim.cmd('highlight NeoTreeDirectoryIcon guifg=' .. selenized.colors.blue)
    vim.cmd('highlight NeoTreeDirectoryName guifg=' .. selenized.colors.blue)
    -- Color render-markdown
    vim.cmd('highlight RenderMarkdownDash guifg=' .. selenized.colors.dim_0 .. ' guibg=' .. selenized.colors.bg_2)
  end,
}
