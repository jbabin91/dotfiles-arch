local core_modules = {
  "options",
  "keymaps",
}

for _, mod in ipairs(core_modules) do
  local ok, err = pcall(require, "core." .. mod)
  if not ok then
    vim.notify(
      string.format("--- Module '%s' ---\n failed to load due to error: %s", mod, err)
      , vim.log.levels.ERROR
    )
  end
end
