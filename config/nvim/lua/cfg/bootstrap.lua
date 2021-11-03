local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
  vim.notify("Installing packer...")
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  vim.cmd([[packadd packer.nvim]])
end

vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost bootstrap.lua source <afile> | PackerCompile
	augroup end
]])

-- load plugins
return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")
  use({ "junegunn/fzf", run = ":call fzf#install()" })
  use("github/copilot.vim")
  use("norcalli/nvim-colorizer.lua")

  -- tpopes
  use("tpope/vim-surround")
  use("tpope/vim-repeat")

  -- Git
  use({
    "tpope/vim-fugitive",
    requires = { "tpope/vim-rhubarb" },
    config = function()
      local opts = { noremap = true, silent = true }
      local mappings = {
        { "n", "<leader>gc", [[<Cmd>Git commit<CR>]], opts },
        { "n", "<leader>gp", [[<Cmd>Git push<CR>]], opts },
        { "n", "<leader>gs", [[<Cmd>G<CR>]], opts },
      }

      for _, m in pairs(mappings) do
        vim.api.nvim_set_keymap(unpack(m))
      end
    end,
  })
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({ numhl = true })
    end,
  })
  use({
    "rlch/github-notifications.nvim",
    config = function()
      require("github-notifications").setup({
        username = "JBabin91",
        mappings = {
          mark_read = "<Tab>",
          open_in_browser = "<CR>",
        },
      })
    end,
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  })

  -- Testing
  use({
    "vim-test/vim-test",
    config = function()
      local opts = { noremap = true, silent = true }
      local mappings = {
        { "n", "<leader>t", [[<Cmd>TestNearest<CR>]], opts }, -- call test for function in cursor
        { "n", "<leader>tt", [[<Cmd>TestFile<CR>]], opts }, -- call test for current file
      }

      for _, m in pairs(mappings) do
        vim.api.nvim_set_keymap(unpack(m))
      end
    end,
  })
  use({ "ellisonleao/glow.nvim", run = ":GlowInstall" })
  use({ "fatih/vim-go", run = { "GoUpdateBinaries" }, ft = { "go" } })

  -- Plugin Development and Utils
  use("nvim-lua/plenary.nvim")
  use({
    "nvim-lua/telescope.nvim",
    config = function()
      require("plugins.telescope")
    end,
    requires = { "nvim-lua/popup.nvim" },
  })
  use("mjlbach/babelfish.nvim")
  use("folke/lua-dev.nvim")

  -- Editor
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use({
    "mhartington/formatter.nvim",
    config = function()
      require("plugins.formatter")
    end,
  })

  -- LSP, Completion, Linting, and Snippets
  use("rafamadriz/friendly-snippets")
  use({
    "glepnir/lspsaga.nvim",
    config = function()
      require("plugins.lspsaga")
    end,
  })
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.cmp")
    end,
    requires = {
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
    },
  })
  use({
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.lsp")
    end,
    requires = { "williamboman/nvim-lsp-installer" },
  })
  use("Pocco81/TrueZen.nvim")

  -- Visual
  use("folke/tokyonight.nvim")
  use("kyazdani42/nvim-web-devicons")
  use({
    "mhinz/vim-startify",
    config = function()
      vim.g.startify_bookmarks = { "~/.config/nvim/lua" }
    end,
  })
  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("plugins.lualine")
    end,
  })
  use("rcarriga/nvim-notify")

  -- Buffer tabs at top
  use({
    "akinsho/nvim-bufferline.lua",
    config = function()
      require("bufferline").setup({ options = { numbers = "both" } })
    end,
  })

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("plugins.treesitter").config()
    end,
  })
  use("nvim-treesitter/playground")

  -- MISC
  use("dstein64/vim-startuptime")
	use("lewis6991/impatient.nvim")

  if packer_bootstrap then
    vim.notify("Installing plugins...")
    require("packer").sync()
  end
end)
