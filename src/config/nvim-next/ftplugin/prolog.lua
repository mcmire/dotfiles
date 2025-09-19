-- Account for backslashed single quotes in atoms
vim.cmd([[syntax region prologAtom start="'" skip="\\'" end="'" oneline extend]])
