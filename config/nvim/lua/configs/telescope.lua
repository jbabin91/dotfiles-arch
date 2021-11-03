local utils = require("utils")
local map = utils.map
local command = utils.command

local ok, telescope = pcall(require, "telescope")

if ok then
  telescope.setup({
    defaults = {
      sorting_strategy = "ascending",
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--ignore",
        "--hidden",
        "-g",
        "!.git",
      },
      mappings = {
        i = {
          ["<ESC>"] = require("telescope.actions").close,
          ["<C-u>"] = false,
          ["<C-d>"] = false,
        },
      },
    },
  })

  -- Generic Mappings
  map("n", "<leader>T", ":Telescope<CR>")
  map("n", "<leader>t", ":Telescope treesitter<CR>")
  map("n", "<C-p>", "<cmd> require'telescope'.extensions.project.project{}<CR>")

  -- Find * commands/mappings
  command('Files', 'Telescope find_files')
  command('Rg', 'Telescope live_grep')
  command('GrepStr', 'Telescope grep_string')
  command('BLines', 'Telescope current_buffer_fuzzy_find')
  command('History', 'Telescope oldfiles')
  command('Buffers', 'Telescope buffers')

  map('n', '<Leader>f', '<cmd>Files<CR>')
  map('n', '<Leader>sp', '<cmd>Rg<CR>')
  map('n', '<Leader>sd', '<cmd>GrepStr<CR>')
  map('n', '<Leader>b', '<cmd>Buffers<CR>')
  map('n', '<Leader>o', '<cmd>History<CR>')

  -- Git * commands
  command('BCommits', 'Telescope git_bcommits')
  command('Commits', 'Telescope git_commits')
  command('Branchs', 'Telescope git_branches')
  command('GStatus', 'Telescope git_status')

  map('n', '<Leader>gc', '<cmd>Commits<CR>')
  map('n', '<Leader>gp', '<cmd>BCommits<CR>')
  map('n', '<Leader>gb', '<cmd>Branchs<CR>')
  map('n', '<Leader>gs', '<cmd>GStatus<CR>')

  -- Help commands
  command('HelpTags', 'Telescope help_tags')
  command('ManPages', 'Telescope man_pages')

  map('n', '<Leader>H', ':HelpTags<CR>')
  map('n', '<leader>m', ':ManPages<CR>')

  -- Lsp mappings/commands
  map('n', '<Leader>ls', '<cmd>LspSym<CR>')
  command('LspRef', 'Telescope lsp_references')
  command('LspDef', 'Telescope lsp_definitions')
  command('LspSym', 'Telescope lsp_workspace_symbols')
  command('LspAct', 'Telescope lsp_code_actions')
end
