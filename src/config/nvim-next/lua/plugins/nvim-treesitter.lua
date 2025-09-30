return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  -- Sets main module to use for opts
  main = 'nvim-treesitter.configs',
  -- See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      --'markdown',
      --'markdown_inline',
      'query',
      'vim',
      'vimdoc',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      -- Disable Treesitter in Markdown files for now as it's really slow
      disable = { 'markdown' },
      -- Some languages depend on vim's regex highlighting system (such as Ruby)
      -- for indent rules.
      --
      -- If you are experiencing weird indenting issues, add the language to the
      -- list of additional_vim_regex_highlighting and disabled languages for
      -- indent.
      --
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter:
  --
  -- * Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  -- * Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  -- * Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
