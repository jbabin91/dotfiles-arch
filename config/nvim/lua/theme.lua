vim.g.theme = "tokyonight"

-- require from themes folder with theme settings
local ok, theme = pcall(require, vim.g.theme)

if ok then vim.cmd[[colorscheme tokyonight]] end
