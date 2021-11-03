local opt = vim.opt

local function set_ui_options()
  -- opt.termguicolors = true
  opt.mouse = "a"
  opt.number = true
  opt.relativenumber = true
end

local function set_editor_options()
  local options = {}

  for k, v in pairs(options) do
    opt[k] = v
  end
end

local function set_options()
  set_editor_options()
  set_ui_options()
end

local function set_mappings()
  local opts = { noremap = true, silent = true }
  local mappings = {
    { "n", "<leader>E", [[<Cmd>edit $HOME/.config/nvim/lua/cfg/editor.lua<CR>]], opts }, -- quick edit editor.lua file
    { "n", "<leader>P", [[<Cmd>edit $HOME/.config/nvim/lua/cfg/bootstrap.lua<CR>]], opts }, -- quick edit plugins.lua file
    { "n", "<leader>U", [[<Cmd>PackerSync<CR>]], opts }, -- Update all current plugins
    { "n", "<leader>R", [[<Cmd>lua RR()<CR>]], opts }, -- reload all custom modules
    { "n", "<leader>,", [[<Cmd>noh<CR>]], opts }, -- clear search highlight
    { "n", "<leader>z", [[<Cmd>bp<CR>]], opts }, -- move to the previous buffer
    { "n", "<leader>q", [[<Cmd>bp<CR>]], opts }, -- move to the previous buffer (same option, different key)
    { "n", "<leader>x", [[<Cmd>bn<CR>]], opts }, -- move to the next buffer
    { "n", "<leader>w", [[<Cmd>bn<CR>]], opts }, -- move to the next buffer (same option, different key)
    { "n", "<leader>d", [[<Cmd>bd<CR>]], opts }, -- close current buffer
    { "n", "<leader>c", [[<Cmd>cclose<CR>]], opts }, -- close quickfix list
    { "n", "<leader>h", [[<Cmd>split<CR>]], opts }, -- create horizontal split
    { "n", "<leader>v", [[<Cmd>vsplit<CR>]], opts }, -- create vertical split
    { "v", "<", [[<gv]], opts }, -- move code forward in visual mode
    { "v", ">", [[>gv]], opts }, -- move code backwards in visual mode
    { "n", "<leader>n", [[<Cmd>cn<CR>]], opts }, -- move to next item in quickfix list
    { "n", "<leader>p", [[<Cmd>cp<CR>]], opts }, -- move to prev item in quickfix list
  }

  for _, map in pairs(mappings) do
    vim.api.nvim_set_keymap(unpack(map))
  end

  -- remember last cursor position
  vim.cmd([[ autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]])
end

set_options()
set_mappings()
