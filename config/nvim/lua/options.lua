local cmd = vim.cmd
local opt = vim.opt

-- Split directions
opt.splitbelow = true
opt.splitright = false
-- Resize sign column limit
opt.signcolumn = "yes"
-- Color line/column
opt.colorcolumn = "9999"
opt.cursorline = true
opt.cursorcolumn = true
-- Completion menu
opt.pumheight = 20
opt.pumblend = 10
-- Set encoding
opt.encoding = "utf-8"
-- Hidden buffers to switch buffers without saving
opt.hidden = true
-- Enable mouse support
opt.mouse = "a"
-- Auto read file changes
opt.autoread = true
-- Sync nvim clipboard with system clipboard
-- opt.clipboard = "unnamedplus" -- Currently there's an performace issue with wsl
-- Make last window always have a statusline
opt.laststatus = 2
-- Indent
opt.tabstop = 2        -- visual spaces that a tab represents
opt.softtabstop = 2    -- editing spaces that a tab (and its backspace) represent
opt.shiftwidth = 2     -- spaces used in autoindent
opt.expandtab = true   -- turn spaces into tabs
opt.autoindent = true
opt.smartindent = true
-- Wrap behavior
opt.wrap = true
opt.linebreak = true
-- Line numbers
opt.number = true
opt.relativenumber = true
-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
-- Faster update time
opt.updatetime = 200
-- Scroll offsets
opt.scrolloff = 5
opt.sidescrolloff = 4
-- Fillchars
opt.fillchars = "diff:╱,eob: "
opt.list = true
opt.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←" 
-- Jumplist
opt.jumpoptions = "stack"
-- Term colors
opt.termguicolors = true
-- Diff options
-- waiting on: https://github.com/neovim/neovim/pull/14537
-- oddly enough, this option isn't set as a table
opt.diffopt = "filler,vertical,closeoff,internal,indent-heuristic,algorithm:patience"
-- Enable filetype plugin
cmd("filetype plugin indent on")
cmd("set formatoptions-=c")
cmd("set formatoptions-=r")
cmd("set formatoptions-=o")
-- Disable vim filetypes
vim.g.did_load_filetypes = 1
-- Folding (with Treesitter)
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldlevel = 99
-- Set fold method to marker
-- opt.foldmethod = "marker"
function _G.custom_fold_expr()
  local line = vim.fn.getline(vim.v.foldstart)
  local sub = vim.fn.substitute(line, [[/*|*/|{{{\d=]], "", "g")
  return sub .. " (" .. tostring(vim.v.foldend - vim.v.foldstart) .. " lines)"
end
opt.foldtext = "v:lua.custom_fold_expr()"
