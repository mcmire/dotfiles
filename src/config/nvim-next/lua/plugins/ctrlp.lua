return {
  'ctrlpvim/ctrlp.vim',
  -- It's already lazy
  lazy = false,
  init = function()
    -- We position Ctrl-P at the top, set the maximum number of matches to 20, and
    -- have better matches appear before worse ones:
    vim.g.ctrlp_match_window_bottom = 0
    vim.g.ctrlp_match_window_reversed = 0
    vim.g.ctrlp_max_height = 20

    -- Usually Ctrl-P's working directory is the same as the open file, but since we
    -- usually have whole projects open, it's better to use the current working
    -- directory:
    vim.g.ctrlp_working_path_mode = 'w'

    -- We use Ag to generate search results.
    -- TODO: Change to ripgrep

    if vim.fn.executable 'ag' then
      vim.g.ctrlp_user_command = 'ag %s --path-to-ignore ~/.ignore --hidden --files-with-matches --nocolor --filename-pattern ""'
    end
  end,
}
