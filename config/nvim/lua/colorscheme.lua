-- Tokyonight config
vim.g.tokyonight_style = "night" -- Options "storm", "night", and "day"
vim.g.tokyonight_italic_functions = true
-- vim.g.tokyonight_italic_variables = true

-- Nightfly config
vim.g.nightflyCursorColor         = 1
vim.g.nightflyUnderlineMatchParen = 0
vim.g.nightflyNormalFloat         = 1

vim.cmd("colorscheme " .. EcoVim.colorscheme)

if EcoVim.colorscheme == "nightfly" then
  -- Errors
  vim.highlight.create("LspDiagnosticsVirtualTextError", { guifg = "Red", ctermfg = "Red", gui = "bold" }, false)
  vim.highlight.create("DiagnosticVirtualTextError", { guifg = "Red", ctermfg = "Red", gui = "bold" }, false)

  -- Warnings
  vim.highlight.create("LspDiagnosticsVirtualTextWarning", { guifg = "Yellow", ctermfg = "Yellow" }, false)
  vim.highlight.create("DiagnosticVirtualTextWarn", { guifg = "Yellow", ctermfg = "Yellow" }, false)

  -- Info & Hints
  vim.highlight.create("DiagnosticVirtualTextInfo", { guifg = "White", ctermfg = "White" }, false)
  vim.highlight.create("DiagnosticVirtualTextHint", { guifg = "White", ctermfg = "White" }, false)

  -- Cursor line
  vim.highlight.create("CursorLineNR", { guifg = "Yellow", ctermfg = "Yellow", guibg = "None", cterm = "bold" }, false)

  -- Comment in italics
  vim.highlight.create("Comment", { gui = "italic", cterm = "italic" }, false)
end
