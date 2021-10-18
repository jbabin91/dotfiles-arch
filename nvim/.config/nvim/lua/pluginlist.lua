local filetypes = require 'base'.lsp_filetypes

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute('packadd packer.nvim')
end

return require 'packer'.startup(function(use)
    use {'wbthomason/packer.nvim'}
    -- Add other user ... for other packages
    use {'kyazdani42/nvim-web-devicons'}
    use {
        'nvim-lua/plenary.nvim',
        after = 'bufferline.nvim',
    }
    -- telescope
    use {
        'nvim-telescope/telescope.nvim',
        setup = function() require 'mappings'.telescope() end,
        after = 'plenary.nvim',
    }
    -- git stuff
    use {
        'lewis6991/gitsigns.nvim',
        opt = true,
        event = 'BufRead',
        config = function() require 'plugins.gitsigns' end,
    }
    -- File explorer
    use {
        'kyazdani42/nvim-tree.lua',
        cmd = 'NvimTreeToggle',
        setup = function() require 'mappings'.nvimtree() end,
        config = function() require 'plugins.nvimtree' end,
    }
    -- LSP
    use { 'kabouzeid/nvim-lspinstall' }
    use {
        'neovim/nvim-lspconfig',
        ft = filetypes,
        config = function() require 'plugins.lsp' end,
    }
    use {
        'tami5/lspsaga.nvim',
        after = 'nvim-lspconfig',
        setup = function() require 'mappings'.lspsaga() end,
        config = function() require 'lspsaga'.init_lsp_saga() end,
    }
    -- Formatting
    use {
        'mhartington/formatter.nvim',
        ft = filetypes,
        cmd = 'Format',
        setup = function() require 'mappings'.formatter() end,
        config = function() require 'plugins.format' end,
    }
    --
    use {
        'nvim-lua/lsp-status.nvim',
        after = 'nvim-lspconfig',
        config = function() require 'plugins.lsp-status' end,
    }

    use {
        'ray-x/lsp_signature.nvim',
        after = 'lspsaga.nvim',
        config = function() require 'plugins.signature' end,
    }

    use {
        'akinsho/bufferline.nvim',
        setup = function() require 'mappings'.bufferline() end,
        config = function() require 'bufferline'.setup {} end,
    }

    use {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        config = function() require 'plugins.cmp' end,
    }

    use {
        'L3MON4D3/LuaSnip',
        after = 'nvim-cmp',
    }

    use {
        'saadparwaiz1/cmp_luasnip',
        after = 'LuaSnip',
    }

    use {
        'hrsh7th/cmp-nvim-lsp',
        after = 'cmp_luasnip',
    }

    use {
        'hrsh7th/cmp-buffer',
        after = 'cmp-nvim-lsp',
    }

    use {
        'hrsh7th/cmp-path',
        after = 'cmp-buffer',
    }

    use {
        'glepnir/galaxyline.nvim',
        config = function() require 'plugins.eviline' end,
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        ft = filetypes,
        run = ':TSUpdate',
        event = 'BufRead',
        config = function() require 'plugins.treesitter' end,
    }

    use {
        'folke/lsp-colors.nvim',
        after = 'nvim-lspconfig',
        config = function() require 'lsp-colors'.setup {} end,
    }

    use {
        'windwp/nvim-autopairs',
        after = 'nvim-cmp',
        config = function() require 'plugins.autopairs' end,
    }

    use {
        'folke/trouble.nvim',
        after = 'nvim-lspconfig',
        setup = function() require 'mappings'.trouble() end,
        config = function() require 'trouble'.setup {} end,
    }

    use {
        'folke/tokyonight.nvim',
        config = function() require 'plugins.theme' end,
    }
end)