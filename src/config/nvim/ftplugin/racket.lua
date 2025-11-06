-- ******************************
-- Settings for Racket files
-- ******************************

-- Treat standard functions used in tests as special keywords
-- (like `if`, `let`, etc.) and indent subsequent lines by 2 spaces instead
-- of aligning with the function name
vim.opt_local.lispwords:append { 'describe', 'context', 'it' }

-- Override `=` to work with Racket files
-- Note that you need to install `vim-racket` for this to work
-- (Technically this belongs in plugin configuration but we will move it later)
vim.bo.equalprg = vim.g.plugin_dir .. '/scmindent/scmindent.rkt'
