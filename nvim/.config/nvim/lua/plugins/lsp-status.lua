local lsp_status = require 'lsp-status'
lsp_status.config {
    indicator_hint = ' ',
    indicator_info = ' ',
    status_symbol = ''
}
lsp_status.register_progress()

local lspconfig = require 'lspconfig'
local lsp_installer = require 'nvim-lsp-installer'

local capabilities = lsp_status.capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)
