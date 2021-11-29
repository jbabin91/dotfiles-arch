local M = {}

-- Auto-install

local lsp_installer_servers = require("nvim-lsp-installer.servers")

if ok then
  if not graphql:is_installed() then
    graphql:install()
  end
end

-- Settings

M.settings = {}

return M
