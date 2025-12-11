---@param startpath string
---@param func function
---@return string|nil
local function search_ancestors(startpath, func)
  local guard = 100
  for path in vim.fs.parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

local M = {}

---@param bufnr integer
---@return string|nil
function M.get_typescript_project_dir(bufnr)
  local fname = type(bufnr) == 'string' and bufnr or vim.api.nvim_buf_get_name(bufnr)

  local function has_package_json(path)
    return vim.fn.filereadable(vim.fn.join({ path, 'package.json' }, '/')) == 1
  end

  local function has_tsconfig(path)
    return vim.fn.filereadable(vim.fn.join({ path, 'tsconfig.json' }, '/')) == 1
  end

  local function has_jsconfig(path)
    return vim.fn.filereadable(vim.fn.join({ path, 'jsconfig.json' }, '/')) == 1
  end

  -- NOTE: This is different from the version in `typescript-tools`
  -- because if we don't detect the right project then we don't activate the LSP
  local root_dir = search_ancestors(fname, has_package_json) and (search_ancestors(fname, has_tsconfig) or search_ancestors(fname, has_jsconfig))

  if root_dir ~= nil then
    -- Ignore node_modules
    local node_modules_index = root_dir:find('node_modules', 1, true)
    if node_modules_index ~= nil and node_modules_index > 0 then
      root_dir = root_dir:sub(1, node_modules_index - 2)
    end
  end

  return root_dir
end

---@param bufnr integer
---@return string|nil
function M.get_deno_project_dir(bufnr)
  local fname = type(bufnr) == 'string' and bufnr or vim.api.nvim_buf_get_name(bufnr)

  local function has_package_json(path)
    return vim.fn.filereadable(vim.fn.join({ path, 'package.json' }, '/')) == 1
  end

  local function has_deno_config(path)
    return vim.fn.filereadable(vim.fn.join({ path, 'deno.json' }, '/')) == 1
  end

  -- NOTE: This is different from the version in `typescript-tools`
  -- because if we don't detect the right project then we don't activate the LSP
  local root_dir = search_ancestors(fname, has_package_json) and search_ancestors(fname, has_deno_config)

  if root_dir ~= nil then
    -- Ignore node_modules
    local node_modules_index = root_dir:find('node_modules', 1, true)
    if node_modules_index ~= nil and node_modules_index > 0 then
      root_dir = root_dir:sub(1, node_modules_index - 2)
    end
  end

  return root_dir
end

return M
