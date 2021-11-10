local execute = vim.api.nvim_command
local fn = vim.fn

-- If Packer is not installed, download and install it
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone --depth=1 https://github.com/wbthomason/packer.nvim " .. install_path)
  execute("packadd packer.nvim")
end

-- Packer commands
vim.cmd [[command! PackerInstall packadd packer.nvim | lua require('plugins').install()]]
vim.cmd [[command! PackerUpdate packadd packer.nvim | lua require('plugins').update()]]
vim.cmd [[command! PackerSync packadd packer.nvim | lua require('plugins').sync()]]
vim.cmd [[command! PackerClean packadd packer.nvim | lua require('plugins').clean()]]
vim.cmd [[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]]
vim.cmd [[command! PackerStatus packadd packer.nvim | lua require('plugins').status()]]
vim.cmd [[command! PC PackerCompile]]
vim.cmd [[command! PS PackerStatus]]
vim.cmd [[command! PU PackerSync]]

require("packer").startup({
  function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"
    -- Improve startup time until: https://github.com/neovim/neovim/pull/15436
    use "lewis6991/impatient.nvim"
    use "nathom/filetype.nvim"
    -- tpope plugins
    use "tpope/vim-commentary" -- "gc" to comment visual regions/lines
    use { "tpope/vim-fugitive", event = "User InGitRepo" } -- Git commands in nvim
    use "tpope/vim-repeat" -- enable repeating supported plugins with "."
    use "tpope/vim-rhubarb" -- Fugitive-companion to interact with github
    use "tpope/vim-speeddating" -- use CTRL-A/CTRL-X to increment dates, times, and more
    use "tpope/vim-surround" -- quoting/parenthesizing made simple
    use "tpope/vim-unimpaired" -- Pairs of handy bracket mappings
    -- Themes
    use "folke/tokyonight.nvim"
    use "EdenEast/nightfox.nvim"
    use "gruvbox-community/gruvbox"
    use "joshdick/onedark.vim"
    use "overcache/NeoSolarized"
    use "bluz71/vim-nightfly-guicolors"
    -- Editor navigation
    use {
      "phaazon/hop.nvim",
      branch = "v1",
      config = function()
        require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
      end,
    }
    -- Startup time
    use "dstein64/vim-startuptime"
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({border = "single"})
      end,
    },
  },
})
