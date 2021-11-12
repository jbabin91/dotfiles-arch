local nvim_command = vim.api.nvim_command

function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    nvim_command("augroup " .. group_name)
    nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{ "autocmd", def }, " ")
      nvim_command(command)
    end
    nvim_command("augroup END")
  end
end

local autocmds = {
  packer = {
    { "BufWritePost", "plugins.lua", "source <afile> | PackerCompile" },
  },
  misc = {
    { "FocusGained,BufEnter", "*", ":checktime" },
    { "VimResized", "*", ":wincmd =" },
  },
  ui = {
    { "TextYankPost", "*", "silent!", [[lua vim.highlight.on_yank({ higroup="search", timeout = 2000})]] },
    { "BufRead", "*", [[call setpos(".", getpos("'\""))]] },
  },
  numbers = {
    -- { "InsertEnter", "*", ":set norelativenumber" },
    -- { "InsertEnter", "*", ":set relativenumber" },
  },
}

nvim_create_augroups(autocmds)
