local M = {}

-- Auto-install

local lsp_installer_servers = require("nvim-lsp-installer.servers")

local ok, lua = lsp_installer_servers.get_server("sumneko_lua")

if ok then
  if not lua:is_installed() then
    lua:install()
  end
end

-- Settings

M.settings = {
  Lua = {
    runtime = {
      -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      version = 'LuaJIT',
    },
    diagnostics = {
      enable = true,
      globals = { "vim" },
      disable = { "redundant-parameters" }
    },
    workspace = {
      -- adjust these two values if your performance is not optimal
      maxPreload = 2000,
      preloadFileSize = 1000,
    },
    telemetry = {
      enable = false,
    },
  },
}

return M
