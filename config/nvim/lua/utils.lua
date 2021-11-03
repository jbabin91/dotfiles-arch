local format = string.format
local uv = vim.loop
local api = vim.api

local M = {}

M.map = function(mode, keys, cmd, opt)
  local options = { noremap = true, silent = true }
  if opt then
    options = vim.tbl_extend("force", options, opt)
  end

  -- all valid modes allowed for mappings
  -- :h map-modes
  local valid_modes = {
    [""] = true,
    ["n"] = true,
    ["v"] = true,
    ["s"] = true,
    ["x"] = true,
    ["o"] = true,
    ["!"] = true,
    ["i"] = true,
    ["l"] = true,
    ["c"] = true,
    ["t"] = true,
  }

  -- helper function for M.map
  -- can gives multiple modes and keys
  local function map_wrapper(_mode, lhs, rhs, _options)
    if type(lhs) == "table" then
      for _, key in ipairs(lhs) do
        map_wrapper(_mode, key, rhs, _options)
      end
    else
      if type(_mode) == "table" then
        for _, m in ipairs(_mode) do
          map_wrapper(m, lhs, rhs, _options)
        end
      else
        if valid_modes[_mode] and lhs and rhs then
          vim.api.nvim_set_keymap(_mode, lhs, rhs, _options)
        else
          _mode, lhs, rhs = _mode or "", lhs or "", rhs or ""
          print(
            "Cannot set mapping [ mode = '"
              .. _mode
              .. "' | key = '"
              .. lhs
              .. "' | cmd = '"
              .. rhs
              .. "' ]"
          )
        end
      end
    end
  end

  map_wrapper(mode, keys, cmd, options)
end

local get_map_options = function()
  local options = { noremap = true, silent = true }
  if custom_options then
    options = vim.tbl_extend("force", options, custom_options)
  end
  return options
end

M.buf_map = function(mode, target, source, opts, bufnr)
  api.nvim_buf_set_keymap(bufnr or 0, mode, target, source, get_map_options(opts))
end

M.command = function(name, fn)
  vim.cmd(format("command! %s %s", name, fn))
end

M.lua_command = function(name, fn)
  M.command(name, "lua " .. fn)
end

M.highlight = function(group, guifg, guibg, attr, guisp)
  local parts = { group }
  if guifg then
    table.insert(parts, "guifg=" .. guifg)
  end
  if guibg then
    table.insert(parts, "guibg=" .. guibg)
  end
  if attr then
    table.insert(parts, "gui=" .. attr)
  end
  if guisp then
    table.insert(parts, "guisp=#" .. guisp)
  end

  vim.api.nvim_command("highlight " .. table.concat(parts, " "))
end

return M
