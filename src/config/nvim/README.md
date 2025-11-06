# Neovim configuration

This is a completely new configuration for Neovim.

I had two goals for this configuration:

- I wanted to rewrite the whole configuration in Lua.
- I wanted to make use of new Lua plugins that have come out in the last 10 years.

Most of the behavior is the same, but here is a list of changes:

- VimPlug has been replaced with [Lazy.vim](https://github.com/folke/lazy.nvim).
- Solarized and manual color configuration has been replaced with [Selenized](https://github.com/calind/selenized.nvim) and automatic color selection via [Tinted Theming](https://github.com/tinted-theming/home).
- NERDTree has been replaced with [`neo-tree`](https://github.com/nvim-neo-tree/neo-tree.nvim).
- Ack has been replaced with [`nvim-rg`](https://github.com/duane9/nvim-rg).
- SuperTab has been replaced with [`blink.cmp`](https://github.com/Saghen/blink.cmp).
- AutoPairs has been replaced with [`autoclose`](https://github.com/m4xshen/autoclose.nvim).
- `endwise` has been replaced with [`nvim-treesitter-endwise`](https://github.com/RRethy/nvim-treesitter-endwise).
- `indentLine` has been replaced with [`indent-blankline`](https://github.com/lukas-reineke/indent-blankline.nvim).
- `vim-surround` has been replaced with [`nvim-surround`](https://github.com/kylechui/nvim-surround).
- `togglecursor` has been replaced with the use of the `guicursor` setting.
- CoC has been replaced with Vim's built-in LSP support, [Mason](https://github.com/mason-org/mason.nvim) + related tools, and [Conform](https://github.com/stevearc/conform.nvim).
- `copilot.vim` has been replaced with `copilot.lua`.
- Treesitter support via [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) has been added.
- [`which-key`](https://github.com/folke/which-key.nvim) has been added.
