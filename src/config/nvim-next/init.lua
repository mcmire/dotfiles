-- mcmire's Neovim configuration
--
-- This Neovim configuration was heavily inspired by:
-- <https://github.com/nvim-lua/kickstart.nvim>
-- and
-- <https://github.com/dam9000/kickstart-modular.nvim>
--
-- Feel free to fork and make your own
-- (or start directly with nvim-kickstart).

require 'start' -- was "magic"
require 'globals'
--require 'lsp-hover'
require 'plugins'
require 'basic-settings'
-- require 'colors'
require 'whitespace-settings'
require 'line-wrapping-settings'
-- NOTE: search settings were removed
require 'completion-settings'
require 'filetype-assignments'
-- NOTE: folding settings were removed
require 'window-settings'
require 'scrolling-settings'
require 'mappings'
-- NOTE: optimizations were removed
require 'line-width-settings'
require 'clipboard-settings'
-- NOTE: indentation settings were moved to ftplugin
require 'autoreloading'
-- NOTE: substitutions were removed
