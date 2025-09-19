-- ******************************
-- Filetype assignments
-- ******************************

-- Some files don't end in extensions that make their filetypes easily
-- recognizable, this is an attempt to fix that

local autoreload_group = vim.api.nvim_create_augroup('custom-file-type-assignments', { clear = true })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { 'config.ru', 'Gemfile', 'Guardfile', 'Rakefile', 'Thorfile', 'Vagrantfile', 'Appraisals', 'Bowerfile', '*.gemspec' },
  desc = 'Assign filetype for Ruby config files',
  group = autoreload_group,
  callback = function()
    vim.bo.ft = 'ruby'
  end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '.jshintrc', '.eslintrc', '.babelrc', '.prettierrc' },
  desc = 'Assign filetype for JSON config files',
  group = autoreload_group,
  callback = function()
    vim.bo.ft = 'json'
  end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '.*.{md,mkd,mkdn,mark*}' },
  desc = 'Assign filetype for Markdown files',
  group = autoreload_group,
  callback = function()
    vim.bo.ft = 'markdown'
  end
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.pro' },
  desc = 'Assign filetype for Yarn Prolog constraint files',
  group = autoreload_group,
  callback = function()
    vim.bo.ft = 'prolog'
  end
})
