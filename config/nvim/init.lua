local modules = {
  -- "impatient",        -- Comment this line on first load
}

for _, mod in ipairs(modules) do
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify(
      string.format("--- Module '%s' ---\n failed to load due to error: %s", mod, err)
      , vim.log.levels.ERROR
    )
  end
end
