local u = require("utils")
local map = u.map

-- Hop
map("n", "h", [[<cmd>lua require("hop").hint_words()<CR>]])
map("n", "l", [[<cmd>lua require("hop").hint_lines()<CR>]])
map("v", "h", [[<cmd>lua require("hop").hint_words()<CR>]])
map("v", "l", [[<cmd>lua require("hop").hint_lines()<CR>]])
vim.cmd([[
  hi HopNextKey guifg=#ff9900
  hi HopNextKey1 guifg=#ff9900
  hi HopNextKey2 guifg=#ff9900
]])
