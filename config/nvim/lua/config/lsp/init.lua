-------------------------
--  LangServer Setup   --
-------------------------

local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings
  local opts = { noremap = true, silent = true }

  buf_set_keymap("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
  buf_set_keymap("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts)
  buf_set_keymap("n", "K", [[<cmd>lua vim.lsp.buf.hover()<CR>]], opts)
  buf_set_keymap("n", "<C-k>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], opts)
  buf_set_keymap("n", "<leader>D", [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
  buf_set_keymap("n", "<leader>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]], opts)
  buf_set_keymap("n", "<leader>ca", [[<cmd>lua vim.lsp.buf.code_action()<CR>]], opts)
  buf_set_keymap("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]], opts)
  buf_set_keymap("n", "<leader>e", [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]], opts)
  buf_set_keymap("n", "[d", [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], opts)
  buf_set_keymap("n", "]d", [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], opts)
  buf_set_keymap("n", "<leader>f", [[<cmd>lua vim.lsp.buf.formatting()<CR>]], opts)
end

local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl})
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    prefix = '●', -- '■', '▎', 'x'
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]])

local border = {
  {"🭽", "FloatBorder"},
  {"▔", "FloatBorder"},
  {"🭾", "FloatBorder"},
  {"▕", "FloatBorder"},
  {"🭿", "FloatBorder"},
  {"▁", "FloatBorder"},
  {"🭼", "FloatBorder"},
  {"▏", "FloatBorder"},
}

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = border}),
}

-------------------------
--   Autocompletion    --
-------------------------
require("config.lsp.cmp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
--capabilities.textDocument.completion.completionItem.snippetSupport = true

-- local servers = {
-- }

-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
--     handlers = handlers,
--     flags = {
--       debounce_text_changes = 150,
--     },
--   })
-- end

require("lspconfig").sumneko_lua.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      }
    },
  },
})

local null_ls = require("null-ls")
local lSsources = {
  null_ls.builtins.formatting.prettier.with({
    filetypes = {
      "javascript",
      "typescript",
      "css",
      "scss",
      "html",
      "json",
      "yaml",
      "markdown",
      "graphql",
      "md",
      "text",
    },
  }),
  null_ls.builtins.formatting.stylua.with({
    args = { "--indent-with", "2", "--indent-type", "Spaces", "-" },
  }),
}
require("null-ls").config({
  sources = lSsources,
})

require("lspconfig")["null-ls"].setup({})

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    flags = {
      debounce_text_changes = 150,
    }
  }
  server:setup(opts)
end)

vim.cmd([[autocmd BufWritePost * lua vim.lsp.buf.formatting_seq_sync(nil, 7500)]])

local saga = require("lspsaga")
saga.init_lsp_saga({
  code_action_icon = " ",
  definition_preview_icon = "  ",
  diagnostic_header_icon = "   ",
  error_sign = " ",
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  hint_sign = "⚡",
  infor_sign = "",
  warn_sign = "",
})
