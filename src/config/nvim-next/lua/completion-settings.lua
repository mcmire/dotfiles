-- ******************************
-- Completion settings
-- ******************************

-- The first time Tab is pressed, choose the longest subsequence that completes
-- what was already typed; the second time, choose the next full match. Either
-- way, always show a list of all available options so we can toggle through
-- them.
vim.opt.wildmode = {'list:longest', 'list:full'}

-- TODO: Copy over wildignore?
