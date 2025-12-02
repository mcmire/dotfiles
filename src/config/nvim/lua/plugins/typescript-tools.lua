---@param startpath string
---@param func function
---@return string|nil
local function search_ancestors(startpath, func)
  local guard = 100
  for path in vim.fs.parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

---@param bufnr integer
---@return string|nil
local function get_root_dir(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local function has_tsconfig(path)
    return vim.fn.filereadable(vim.fn.join { path, 'tsconfig.json' }) == 1
  end

  local function has_root_files(path)
    local root_files = { 'jsconfig.json', 'package.json' }
    for _, file in ipairs(root_files) do
      if vim.fn.filereadable(vim.fn.join({ path, file }, '/')) == 1 then
        return true
      end
    end
    return false
  end

  -- NOTE: This is different from the version in `typescript-tools`
  -- because if we don't detect the right project then we don't activate the LSP
  local root_dir = search_ancestors(fname, has_tsconfig) or search_ancestors(fname, has_root_files)

  -- INFO: this is needed to make sure we don't pick up root_dir inside node_modules
  local node_modules_index = root_dir and root_dir:find('node_modules', 1, true)
  if root_dir and node_modules_index and node_modules_index > 0 then
    root_dir = root_dir:sub(1, node_modules_index - 2)
  end

  return root_dir
end

return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    settings = {
      tsserver_file_preferences = {
        -- importModuleSpecifierPreference = 'project-relative',
      },
    },
    root_dir = function(bufnr, on_dir)
      local root_dir = get_root_dir(bufnr)

      if root_dir then
        on_dir(root_dir)
      end
    end,
  },
}
