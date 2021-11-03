local status_ok, indent_blankline = pcall(require, "indent_blankline")

if status_ok then
	local M = {}

	M.config = {
	  char = '▏',
	  show_first_indent_level = true,
	  filetype_exclude = {
	    "startify", "dashboard", "dotooagenda", "log", "fugitive", "gitcommit",
	    "packer", "vimwiki", "markdown", "json", "txt", "vista", "help",
	    "todoist", "NvimTree", "peekaboo", "git", "TelescopePrompt", "undotree",
	    "flutterToolsOutline", "" -- for all buffers without a file type
	  },
	  buftype_exclude = { "terminal", "nofile" },
	  show_trailing_blankline_indent = false,
	  show_current_context = true,
	  context_patterns = {
	    "class", "function", "method", "block", "list_literal", "selector",
	    "^if", "^table", "if_statement", "while", "for", "type", "var", "import"
	  },
	}

	local cmd = vim.cmd
	local g = vim.g

	cmd [[hi IndentOne guifg=#BF616A guibg=NONE gui=nocombine]]
	cmd [[hi IndentTwo guifg=#D08770 guibg=NONE gui=nocombine]]
	cmd [[hi IndentThree guifg=#EBCB8B guibg=NONE gui=nocombine]]
	cmd [[hi IndentFour guifg=#A3BE8C guibg=NONE gui=nocombine]]
	cmd [[hi IndentFive guifg=#5E81AC guibg=NONE gui=nocombine]]
	cmd [[hi IndentSix guifg=#88C0D0 guibg=NONE gui=nocombine]]
	cmd [[hi IndentSeven guifg=#B48EAD guibg=NONE gui=nocombine]]

	g.indent_blankline_char = "┊" --  "│" 
	g.indent_blankline_char_highlight_list = {
	"IndentOne", "IndentTwo", "IndentThree", "IndentFour", "IndentFive",
	"IndentSix", "IndentSeven"
	}
	g.indent_blankline_show_first_indent_level = true
	g.indent_blankline_filetype_exclude = {
	"startify", "dashboard", "dotooagenda", "log", "fugitive", "gitcommit",
	"packer", "vimwiki", "markdown", "json", "txt", "vista", "help",
	"todoist", "NvimTree", "peekaboo", "git", "TelescopePrompt", "undotree",
	"flutterToolsOutline", "" -- for all buffers without a file type
	}
	g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
	g.indent_blankline_show_trailing_blankline_indent = false
	g.indent_blankline_show_current_context = true
	g.indent_blankline_context_patterns = {
	"class", "function", "method", "block", "list_literal", "selector",
	"^if", "^table", "if_statement", "while", "for"
	}
	cmd[[set colorcolumn=99999]]
	-- because lazy load indent-blankline so need this autocmd
	cmd[[ autocmd CursorMoved * IndentBlanklineRefresh ]]
end
