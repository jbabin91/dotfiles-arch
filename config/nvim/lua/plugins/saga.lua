local saga = require("lspsaga")

saga.init_lsp_saga({
  code_action_icon   = "💡",
  code_action_prompt = {
    enable           = true,
    sign             = true,
    sign_priority    = 15,
    virtual_text     = false,
  },
  code_action_keys   = { quit = { "q", "<ESC>" }, exec = "<CR>" },
  border_style       = "round",
})

-- Keymappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts)
map("n", "gD", [[<cmd>lua require("lspsaga.provider").preview_definition()<CR>]], opts)
map("n", "gr", [[<cmd>lua require("lspsaga.provider").lsp_finder()<CR>]], opts)
map("n", "<C-Space>", [[<cmd>lua require("lspsaga.codeaction").code_action()<CR>]], opts)
map("n", "<leader>ca", [[<cmd>lua require("lspsaga.codeaction").code_action()<CR>]], opts)
map("v", "<leader>ca", [[<cmd>'<,'>lua require("lspsaga.codeaction").range_code_action()<CR>]], opts)
map("n", "<leader>cr", [[<cmd>lua require("lspsaga.rename").rename()<CR>]], opts)
map("n", "<leader>cf", [[<cmd>lua vim.lsp.buf.formatting()<CR>]], opts)
map("v", "<leader>cf", [[<cmd>'<,'>lua vim.lsp.buf.range_formatting()<CR>]], opts)
map("n", "K", [[<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>]], opts)
map("n", "<C-k>", [[<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>]], opts)
map("n", "[g", [[<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_prev()<CR>]], opts)
map("n", "]g", [[<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_next()<CR>]], opts)
map("n", "<C-f>", [[<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>]], opts)
map("n", "<C-b>", [[<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>]], opts)
map("n", "<leader>cl", [[<cmd>lua require("lspsaga.diagnostic").show_line_diagnostics()<CR>]], opts)
