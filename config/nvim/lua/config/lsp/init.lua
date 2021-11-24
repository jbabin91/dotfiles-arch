local modules = {
  "config",
  "bash",
  "css",
  "graphql",
  "html",
  "json",
  "lua",
  "tsserver"
}

for _, mod in ipairs(modules) do
  local ok, err = pcall(require, "config.lsp." .. mod)
  if not ok then
    vim.notify(
      string.format("--- Module '%s' ---\n failed to load due to error: %s", mod, err)
      , vim.log.levels.ERROR
    )
  end
end
