return {
  'AndrewRadev/splitjoin.vim',
  -- This plugin is small enough
  lazy = false,
  init = function()
    -- When taking a Ruby hash split across multiple lines and turning it into a
    -- single line, keep the curly braces around the hash
    vim.g.splitjoin_ruby_curly_braces = false
    -- When splitting up a Ruby method that's one line into multiple lines,
    -- place the arguments on their own line instead of placing the first
    -- argument on the same line as the method call:
    vim.g.splitjoin_ruby_hanging_args = false
  end,
}
