local utils = require("utils")
local map = utils.map

-- Keymappings
-- Remap space as leader key
map("", "<space>", "<nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y, or c behaviour
map("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- Sneak F & T
map("", "f", "<Plug>Sneak_f", {})
map("", "F", "<Plug>Sneak_F", {})
map("", "t", "<Plug>Sneak_t", {})
map("", "T", "<Plug>Sneak_T", {})
-- jumping
-- map("n", "g[", "<C-o>")
-- map("n", "g]", "<C-i>")

-- Formatting
map("n", "<leader>f", "<cmd>:Format<cr>")

-- CHADTree
-- map("n", "<leader>v", [[<cmd>CHADopen<CR>]])

-- turn off search highlighting
map("n", "<C-n>", ":noh <CR>")
-- Convenient Keybindings
map("n", "<leader>/", "<cmd>nohlsearch<Bar>diffupdate<CR><C-L>")

-- Don't copy the replaced text after pasting in visual mode
map("v", "p", '"_dP')
-- vim.api.nvim_set_keymap("v", "<leader>p", '"_dP', { noremap = true, silent = true })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Y yank until till end of line
map("n", "Y", "y$", { noremap = true })
map("v", "y", "ygv<esc>")
-- map("i", "jk", "<esc>", { noremap = true })
-- map("i", "kj", "<esc>", { noremap = true })
map("t", "<C-q>", [[<C-\><C-n>]], { noremap = true })
-- map("t", "jk", [[<C-\><C-n>]], { noremap = true })
-- map("t", "kj", [[<C-\><C-n>]], { noremap = true })
map("t", "<C-h>", [[<C-\><C-n><C-W>h]], { noremap = true })
map("t", "<C-j>", [[<C-\><C-n><C-W>j]], { noremap = true })
map("t", "<C-k>", [[<C-\><C-n><C-W>k]], { noremap = true })
map("t", "<C-l>", [[<C-\><C-n><C-W>l]], { noremap = true })
map("n", "<C-h>", [[<C-W>h]], { noremap = true })
map("n", "<C-j>", [[<C-W>j]], { noremap = true })
map("n", "<C-k>", [[<C-W>k]], { noremap = true })
map("n", "<C-l>", [[<C-W>l]], { noremap = true })

-- Better nav
map("i", "<c-j>", '"\\<c-n>"', { expr = true })
map("i", "<c-k>", '"\\<c-p>"', { expr = true })

-- Buffer nav
-- map("n", "<Tab>", ":WintabsNext<CR>")
-- map("n", "<S-Tab>", ":WintabsPrevious<CR>")

-- Window nav
map("n", "<c-h>", "<c-w>h")
map("n", "<c-j>", "<c-w>j")
map("n", "<c-k>", "<c-w>k")
map("n", "<c-l>", "<c-w>l")
map("n", "<M-h>", ":vertical resize -2<CR>")
map("n", "<M-j>", ":resize -2<CR>")
map("n", "<M-k>", ":resize +2<CR>")
map("n", "<M-l>", ":vertical resize +2<CR>")

-- Use control-c instead of escape
map("n", "<C-c>", "<Esc>")

-- you can't stop me!
map("c", "w!!", "w !sudo tee %")
map("c", "ww", "noa w")

-- Add telescope shortcuts
map("n", "<leader>ff", [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]])
map("n", "<leader>fg", [[<cmd>lua require('telescope.builtin').live_grep()<CR>]])
map("n", "<leader>fb", [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
map("n", "<leader>fh", [[<cmd>lua require('telescope.builtin').help_tags()<CR>]])
map("n", "<leader>fz", [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
map("n", "<leader>ft", [[<cmd>lua require('telescope.builtin').tags()<CR>]])
map("n", "<leader>fs", [[<cmd>lua require('telescope.builtin').grep_string()CR>]])
map("n", "<leader>fo", [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]])
map("n", "<leader>?", [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
