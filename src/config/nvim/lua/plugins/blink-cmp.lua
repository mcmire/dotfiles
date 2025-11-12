local has_words_before = function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then
    return false
  end
  local line = vim.api.nvim_get_current_line()
  return line:sub(col, col):match '%s' == nil
end

return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    completion = {
      menu = {
        -- Don't show the menu automatically, as it is unbelievably distracting.
        -- We'll show it when we want to (see `keymap` below).
        auto_show = false,
      },
    },

    cmdline = {
      -- The default autocompletion behavior for the cmdline works just fine.
      enabled = false,
    },

    fuzzy = {
      -- The default algorithm tries too hard to find matches, creating noise
      max_typos = 0,
    },

    keymap = {
      -- Simulate the behavior of the SuperTab Vim plugin more closely.

      preset = 'none',

      ['<Tab>'] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_next()
          end

          if has_words_before() then
            return cmp.show_and_insert_or_accept_single()
          end
        end,
        'fallback',
      },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<Esc>'] = {
        function(cmp)
          cmp.hide()
          -- Don't return so that we escape Insert mode
        end,
        'fallback',
      },
    },

    sources = {
      -- Populate the completion menu from open buffers, to better mimic SuperTab.
      -- We might add LSP/LazyDev support later.
      default = { 'buffer' },
    },
  },
  init = function()
    -- Dismiss Copilot suggestion when completion menu opens.

    local autogroup = vim.api.nvim_create_augroup('custom-blink-cmp', { clear = true })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuOpen',
      group = autogroup,
      callback = function()
        has_copilot_suggestion, copilot_suggestion = pcall(require, 'copilot.suggestion')

        if has_copilot_suggestion then
          copilot_suggestion.dismiss()
          vim.b.copilot_suggestion_hidden = true
        end
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpMenuClose',
      group = autogroup,
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
}
