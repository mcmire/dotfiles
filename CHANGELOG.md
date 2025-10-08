# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0 - 2025-09-19

I haven't been keeping a changelog for these dotfiles, mostly because I keep them for myself and I get lazy. But in case anyone else is using these, I figured it would be helpful to record the changes. So, here's what's new:

### Changed

- The Neovim configuration has been completely rehauled
  - Everything is now written in Lua instead of VimScript
  - The following plugins have been replaced with Lua equivalents:
    - [x] VimPlug has been replaced with [Lazy](https://github.com/folke/lazy.nvim)
    - [x] Solarized has been replaced with [Selenized](https://github.com/calind/selenized.nvim)
    - [x] NERDTree has been replaced with [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)
      - [`neo-tree`](https://github.com/nvim-neo-tree/neo-tree.nvim) actually looks better, let's use that
    - [x] Ctrl-P has been replaced with [mini.pick](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-pick.md)
      - Or [Picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md) from Snacks?
      - Or [`fzf-lua`](https://github.com/ibhagwan/fzf-lua) ? (Well then I might as well use Telescope)
    - [ ] Ack has been replaced with [`nvim-rg`](https://github.com/duane9/nvim-rg)
      - Actually Telescope too
      - `ripgrep` is required, maybe I just need to require `brew install ripgrep`
    - [x] NERDCommenter has been replaced with Neovim's built in commenting feature (see `:h commenting`)
      - But it would be nice to keep the old mappings
    - [x] SuperTab has been replaced with [`coq.nvim`](https://github.com/ms-jpq/coq_nvim)
      - Or maybe [compl.nvim](https://github.com/brianaung/compl.nvim)?
      - Actually, [blink.cmp](https://github.com/Saghen/blink.cmp) with `super-tab`
    - [ ] AutoPairs has been replaced with [`autoclose`](https://github.com/m4xshen/autoclose.nvim)
    - [ ] `endwise` has been replaced with [`nvim-treesitter-endwise`](https://github.com/RRethy/nvim-treesitter-endwise)
    - [ ] `indentLine` has been replaced with [`simpleIndentGuides`](https://github.com/LucasTavaresA/simpleIndentGuides.nvim)
    - [ ] `vim-surround` has been replaced with [`nvim-surround`](https://github.com/kylechui/nvim-surround)
      - Or maybe [`mini.surround`](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-surround.md)?
    - [ ] `togglecursor` has been replaced with the use of the `guicursor` setting.
    - [x] CoC has been replaced with Vim's built-in LSP support
