local u = require("utils")

local autocmds = {
  reload_vimrc = {
    -- Reload vim config automatically
    { "BufWritePost", [[$VIM_PATH/{*.vim,*.yaml,vimrc,*.lua} nested source $MYVIMRC | redraw]] },
  },
  packer = {
    { "BufWritePost", "plugins.lua", "PackerCompile" },
  },
  terminal_job = {
    { "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] },
    { "TermOpen", "*", "startinsert" },
    { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" },
  },
  restore_cursor = {
    { "BufRead", "*", [[call setpos(".", getpos("'\""))]] },
  },
  resize_windows_proportionally = {
    { "VimResized", "*", ":wincmd =" },
  },
  toggle_search_highlighting = {
    { "InsertEnter", "*", "setlocal nohlsearch" },
  },
  lua_highlight = {
    { "TextYankPost", "*", [[silent! lua vim.highlight.on_yank() { higroup="IncSearch", timeout=400 }]] },
  },
}

u.create_augroups(autocmds)
