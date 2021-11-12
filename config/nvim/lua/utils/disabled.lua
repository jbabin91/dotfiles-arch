vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local builtins = {
  "netrw",
  "netrwPlugins",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in pairs(builtins) do
  vim.g["loaded_" .. plugin] = 1
end
