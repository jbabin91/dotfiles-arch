local execute = vim.api.nvim_command

-- check if packer is installed (~/.local/share/nvim/site/pack)
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local compile_path = install_path .. "/plugin/packer_compiled.lua"
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0

if not is_installed then
  if vim.fn.input("Install packer.nvim? (y for yes) ") == "y" then
    execute("!git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)
    execute("packadd packer.nvim")
    print("Installed packer.nvim")
    is_installed = 1
  end
end

-- Packer commands
vim.cmd [[command! PackerInstall packadd packer.nvim | lua require("plugins").install()]]
vim.cmd [[command! PackerUpdate packadd packer.nvim | lua require("plugins").update()]]
vim.cmd [[command! PackerSync packadd packer.nvim | lua require('plugins').sync()]]
vim.cmd [[command! PackerClean packadd packer.nvim | lua require('plugins').clean()]]
vim.cmd [[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]]
vim.cmd [[command! PackerStatus packadd packer.nvim | lua require('plugins').status()]]
vim.cmd [[command! PC PackerCompile]]
vim.cmd [[command! PS PackerStatus]]
vim.cmd [[command! PU PackerSync]]

local packer = nil
if not is_installed then return end
if packer == nil then
  packer = require("packer")
  packer.init({
    -- we don't want the compilation file in '~/.config/nvim'
    compile_path = compile_path,
  })
end

packer.startup({
  function(use)

	-- Packer can manage itself
	use "wbthomason/packer.nvim"

	-- Needs to load first
	use { "lewis6991/impatient.nvim", rocks = "mpack" }
	use "nathom/filetype.nvim"
	use "nvim-lua/plenary.nvim"
	use "kyazdani42/nvim-web-devicons"
	use "glepnir/dashboard-nvim"

	-- Themes
	use "bluz71/vim-nightfly-guicolors"
	use "folke/tokyonight.nvim"

	-- Treesitter
	use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use { "nvim-treesitter/nvim-treesitter-textobjects", after = { "nvim-treesitter" }}

	-- Telescope
	use {
  	"nvim-telescope/telescope.nvim",
  	requires = {
    	"nvim-lua/popup.nvim",
    	"nvim-lua/plenary.nvim",
    	{"nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  	},
	}
	use {
  	"ahmedkhalf/project.nvim",
  	config = function()
    	require("project_nvim").setup{}
  	end,
	}

	-- General
	use { "ellisonleao/glow.nvim", run = "GlowInstall" }
	use "AndrewRadev/switch.vim"
	use "AndrewRadev/splitjoin.vim"
	use "mbbill/undotree"
	-- use "numToStr/Comment.nvim"
	-- use "b3nj5m1n/kommentary"
	use "tpope/vim-commentary"
	use "akinsho/nvim-toggleterm.lua"
	use "tpope/vim-repeat"
	use "tpope/vim-speeddating"
	use "tpope/vim-surround"
	use "dhruvasagar/vim-table-mode"
	use "mg979/vim-visual-multi"
	use "junegunn/vim-easy-align"
	use { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" }
	use "nacro90/numb.nvim"
	use "folke/todo-comments.nvim"
	use { "folke/which-key.nvim", event = "BufWinEnter" }
	use "folke/zen-mode.nvim"
	use "ggandor/lightspeed.nvim"
	use {
  	"folke/twilight.nvim",
  	config = function()
    	require("twilight").setup{}
  	end,
	}
	use "karb94/neoscroll.nvim"
	use "antoinemadec/FixCursorHold.nvim"
	use "romainl/vim-cool"

	-- UI
	--[[ use {
    "glepnir/galaxyline.nvim",
    requires = { "kyazdani42/nvim-web-devicons" }
  } ]]
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true }
  }
	-- use "itchyny/lightline.vim
	use "lukas-reineke/indent-blankline.nvim"
	use "norcalli/nvim-colorizer.lua"

	-- Language & Syntax
	use "windwp/nvim-autopairs"
	use "p00f/nvim-ts-rainbow"
	use "mattn/emmet-vim"
	use "mhartington/formatter.nvim"
	use "editorconfig/editorconfig-vim"

	-- LSP
	use "neovim/nvim-lspconfig"
	use "williamboman/nvim-lsp-installer"
	use "tami5/lspsaga.nvim"
	use "onsails/lspkind-nvim"
	use "folke/lsp-trouble.nvim"
  use "ray-x/lsp_signature.nvim"
	use { "SmiteshP/nvim-gps", requires = "nvim-treesitter/nvim-treesitter" }
	use { "jose-elias-alvarez/nvim-lsp-ts-utils", after = { "nvim-treesitter" }}
  use "jose-elias-alvarez/null-ls.nvim"

	-- Completion & Snippets
	-- use {
  	-- "ms-jpq/coq_nvim",
  	-- requires = {
    	-- { "ms-jpq/coq.artifacts", branch = "artifacts" },
    	-- -- { "ms-jpq/coq.thirdparty", branch = "3p" },
  	-- },
  	-- branch = "coq",
  	-- setup = function()
    	-- vim.g.coq_settings = {
      	-- keymap = { recommended = false }, -- for autopairs
      	-- auto_start = "shut-up",
      	-- ["display.pum.fast_close"] = false,
      	-- clients = {
        	-- lsp = {
          	-- resolve_timeout = 0.15,
    				-- weight_adjust = 0.4,
  				-- },
    		-- },
    	-- }
  	-- end,
  	-- run = ":COQdeps",
  -- }
  use 
  use "github/copilot.vim"

  -- File Explorer
  use {
  	"kyazdani42/nvim-tree.lua",
  	requires = "kyazdani42/nvim-web-devicons"
  }
	-- use {
	--   "ms-jpq/chadtree",
	--   run = ":CHADdeps",
	--   event = "BufWinEnter",
	-- }

	-- Git
	use {
  	"lewis6991/gitsigns.nvim",
  	requires = { "nvim-lua/plenary.nvim" },
	}
	use "sindrets/diffview.nvim"
	-- use "kdheepak/lazygit.nvim"
	use { "TimUntersberger/neogit", requires = { "nvim-lua/plenary.nvim" }}
	use "tpope/vim-fugitive"
	use "tpope/vim-rhubarb"
	-- use "tpope/vim-commentary"

	-- MISC
	use "dstein64/vim-startuptime"
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end
    },
  },
})
