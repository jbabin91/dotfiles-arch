local cmd = vim.cmd
local opt = vim.opt

-- Move to different file
-- require("config.ui.colors")
cmd("colorscheme tokyonight")
opt.termguicolors = true
opt.background = "dark"

opt.syntax = "on"
opt.number = true
opt.relativenumber = true
opt.cursorcolumn = true
opt.cursorline = true
opt.wrap = true
opt.linebreak = true
opt.mouse = "a"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.laststatus = 2
opt.hidden = true
opt.lazyredraw = true
opt.updatetime = 250
opt.ttyfast = true

opt.showmode = false
opt.showcmd = false
opt.wildmenu = true
opt.cmdheight = 1
opt.timeoutlen = 300
opt.shortmess = opt.shortmess + "c"
opt.completeopt = "menu,menuone,noselect,longest"
opt.backspace = "indent,eol,start"
opt.pumheight = 10
opt.pumblend = 20
opt.winblend = 20

opt.splitbelow = true
opt.splitright = false

-- opt.clipboard = "unnamed,unamedplus"

opt.showmatch = true
opt.hlsearch = false
opt.smartcase = true
opt.ignorecase = true

opt.smartindent = true
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- opt.foldenable = true
-- opt.foldmethod = "syntax"

opt.list = true
-- opt.listchars = "tab:»,extends:›,precedes:‹,nbsp:·,trail:·"

opt.formatoptions = opt.formatoptions - "cro"

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true

require("utils.autocmds")
