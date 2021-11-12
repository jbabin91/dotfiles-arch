local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local compile_path = install_path .. "/plugin/packer_compiled.lua"
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0

if not is_installed then
  if vim.fn.input("Install packer.nvim? (y for yes) ") == "y" then
    execute("!git clone --depth=1 https://github.com/wbthomason/packer.nvim " .. install_path)
    execute("packadd packer.nvim")
    print("Installed packer.nvim")
    is_installed = 1
  end
end

-- Packer commands
vim.cmd([[command! PackerInstall packadd packer.nvim | lua require('plugins').install()]])
vim.cmd([[command! PackerUpdate packadd packer.nvim | lua require('plugins').update()]])
vim.cmd([[command! PackerSync packadd packer.nvim | lua require('plugins').sync()]])
vim.cmd([[command! PackerClean packadd packer.nvim | lua require('plugins').clean()]])
vim.cmd([[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]])
vim.cmd([[command! PackerStatus packadd packer.nvim | lua require('plugins').status()]])
vim.cmd([[command! PC PackerCompile]])
vim.cmd([[command! PS PackerStatus]])
vim.cmd([[command! PU PackerSync]])

local packer = nil
if not is_installed then return end
if packer == nil then
  packer = require("packer")
  packer.init({
    -- we don't want the compilation file in "~/.config/nvim"
    compile_path = compile_path,
    display = {
      non_interactive = false,
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end,
      show_all_info = false,
      -- prompt_border = "single",
    },
  })
end

return require("packer").startup(
  function(use)
    use "wbthomason/packer.nvim"
    -- Themes
    use "folke/tokyonight.nvim"
    -- Tpope
    use "tpope/vim-commentary" -- "gc" to comment visual regions/lines
    -- use "tpope/vim-fugitive" -- Git commands in nvim
    use "tpope/vim-repeat" -- enable repeating supported plugin maps with "."
    -- use "tpope/vim-rhubarb" -- Fugitive-companion to interact with github
    -- use "tpope/vim-speeddating" -- use CTRL-A/CTRL-X to increment dates, times, and more
    use "tpope/vim-surround" -- quoting/parenthesizing made simple
    use "tpope/vim-unimpaired" -- Pairs of handy bracket mappings
    -- UI
    use "glepnir/dashboard-nvim"
    use "akinsho/bufferline.nvim"
    use "glepnir/galaxyline.nvim"
    -- Tools
    -- use "kyazdani42/nvim-tree.lua"
    use "akinsho/toggleterm.nvim"
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
      },
    }
    use "dstein64/vim-startuptime"
    -- Syntax
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use { "plasticboy/vim-markdown", opt = true, ft = "markdown" }
    -- Git
    use "lewis6991/gitsigns.nvim"
    -- Workspace
    use "Pocco81/AutoSave.nvim"
    -- use "terrortylor/nvim-comment"
    use "folke/todo-comments.nvim"
    use "nathom/filetype.nvim"
    use "luukvbaal/stabilize.nvim"
    use "lewis6991/impatient.nvim"
    -- Edit
    use "matze/vim-move"
    use "mg979/vim-visual-multi"
    -- Enhance/Optional
    use "lukas-reineke/indent-blankline.nvim"
    use "norcalli/nvim-colorizer.lua"
    use "p00f/nvim-ts-rainbow"
    use "karb94/neoscroll.nvim"
    -- Auto
    use "windwp/nvim-autopairs"
    use { "windwp/nvim-ts-autotag", ft = "html" }
    use { "AndrewRadev/tagalong.vim", ft = "html" }
    -- LSP
    use "neovim/nvim-lspconfig"
    use "onsails/lspkind-nvim"
    use "tami5/lspsaga.nvim"
    use "jose-elias-alvarez/null-ls.nvim"
    use "williamboman/nvim-lsp-installer"
    -- Snippets
    use "hrsh7th/vim-vsnip"
    use "rafamadriz/friendly-snippets"
    -- Autocompletion
    use {
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-vsnip",
      }
    }
  end
)

-- Suggested Plugins
-- lspsaga.nvim
-- trouble.nvim
-- lsp-colors.nvim
-- formatter.nvim

-- rest.nvim
-- nvim-jqx

-- auto-session
-- sidebar.nvim
-- nvim-gps
-- TrueZen
-- twilight.nvim
-- nvim-spectre

-- octo.nvim

-- sneak
-- mathup
-- register
-- vCoolor
