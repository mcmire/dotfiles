-- ******************************
-- Colors
-- ******************************

-- TODO: Make this more modular? Or perhaps someone has already done this?

-- Enable 24-bit color
-- NOTE: You need to use a terminal capable of 24-bit color, like iTerm
vim.o.termguicolors = true

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
  vim.cmd('source %')
end
vim.api.nvim_create_user_command('VimColorTest', function()
  vim_color_test('/tmp/vim-color-test.tmp', 255, 255)
end, {})

-- Solarized colors:
-- https://github.com/altercation/solarized/blob/e40cd4130e2a82f9b03ada1ca378b7701b1a9110/vim-colors-solarized/colors/solarized.vim#L91

-- Common Solarized colors
local colors = {
  yellow = "#b58900",
  orange = "#cb4b16",
  red = "#dc322f",
  magenta = "#d33682",
  violet = "#6c71c4",
  blue = "#268bd2",
  cyan = "#2aa198",
  green = "#859900"
}

local function chomp(str)
  return str:gsub('\n+$', '')
end

local function set_highlights()
  local highlights = {
    SpecialKey = { fg = colors.base1, bg = colors.base03 },
    SignColumn = { bg = colors.base03 },
    ExtraWhitespace = { fg = colors.base3, bg = colors.red },
    CharsExceedingLineLength = { fg = colors.base3, bg = colors.red },
    IncSearch = { fg = colors.base03, bg = colors.yellow },
    Search = { fg = colors.base03, bg = colors.orange },
    MatchParen = { fg = colors.base03, bg = colors.base01 },
    MarkologyHLl = { fg = colors.base01, bg = colors.base03 },
    MarkologyHLu = { fg = colors.base01, bg = colors.base03 },
    MarkologyHLo = { fg = colors.base01, bg = colors.base03 },
    MarkologyHLm = { fg = colors.base01, bg = colors.base03 },
    -- Default highlight for floating windows, such as those used by CoC
    PMenu = { fg = colors.base3, bg = colors.base02 },
    CocErrorSign = { fg = colors.red },
    CocInfoSign = { fg = colors.blue },
    CocWarningSign = { fg = colors.yellow }
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

local function use_dark_color_scheme()
  colors.base03 = "#002b36"
  colors.base02 = "#073642"
  colors.base01 = "#586e75"
  colors.base00 = "#657b83"
  colors.base0 = "#839496"
  colors.base1 = "#93a1a1"
  colors.base2 = "#eee8d5"
  colors.base3 = "#fdf6e3"

  colors.color_scheme_type = "dark"
  vim.opt.background = "dark"
  pcall(vim.cmd.colorscheme, "solarized8_flat")
  vim.g.airline_theme = "solarized"
  vim.g.airline_solarized_bg = "dark"

  set_highlights()
end

local function use_light_color_scheme()
  colors.base3 = "#002b36"
  colors.base2 = "#073642"
  colors.base1 = "#586e75"
  colors.base0 = "#657b83"
  colors.base00 = "#839496"
  colors.base01 = "#93a1a1"
  colors.base02 = "#eee8d5"
  colors.base03 = "#fdf6e3"

  colors.color_scheme_type = "light"
  vim.opt.background = "light"
  pcall(vim.cmd.colorscheme, "solarized8_flat")
  vim.g.airline_theme = "solarized"
  vim.g.airline_solarized_bg = "light"

  set_highlights()
end

local function refresh_color_scheme(color_scheme_mode)
  color_scheme_mode = color_scheme_mode or chomp(vim.fn.system('color-scheme-mode'))

  if color_scheme_mode == "dark" then
    use_dark_color_scheme()
  elseif color_scheme_mode == "light" then
    use_light_color_scheme()
  else
    error("Unknown color scheme mode " .. color_scheme_mode)
  end
end

-- Switch the global color scheme mode, tell iTerm and tmux to switch,
-- then switch Vim.
--
-- Roughly inspired by: <https://grrr.tech/posts/2020/switch-dark-mode-os/>
local function toggle_color_scheme()
  local new_color_scheme_mode = chomp(vim.fn.system('color-scheme-mode --toggle'))
  vim.fn.system('propagate-color-scheme-mode')
  -- TODO: Propagate this across all instances of Vim
  refresh_color_scheme(new_color_scheme_mode)
end

-- Add commands and mappings
vim.api.nvim_create_user_command('ToggleColorScheme', toggle_color_scheme, {})
vim.keymap.set('n', '<Leader>th', ':ToggleColorScheme<CR>', { silent = true })
vim.api.nvim_create_user_command('RefreshColorScheme', function()
  refresh_color_scheme()
end, {})

-- Switch to the correct variant when Vim starts
-- Source: <https://github.com/lifepillar/vim-solarized8/tree/neovim>
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('local-initialize-color-scheme', { clear = true }),
  nested = true,
  callback = function()
    refresh_color_scheme()
  end
})
