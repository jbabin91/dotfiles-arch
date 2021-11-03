local o, bo, wo = vim.opt, vim.bo, vim.wo

o.autoindent = true                                        -- Good auto indent
o.backspace = "indent,eol,start"                           -- Making sure backspace works
o.backup = false                                           -- Recommended for speed
-- o.clipboard = "unnamed,unnamedplus"                        -- Copy-paste between vim and everything else
o.cmdheight = 2                                            -- Give more space for displaying messages
o.completeopt = "menuone,noselect"                         -- Better autocompletion
o.conceallevel = 0                                         -- Show `` in markdown files
o.confirm = true                                           -- Enables a confirmation prompt when closing nvim
o.cursorcolumn = false                                     -- Highlight current column
o.cursorline = false                                       -- Highlight current line
o.encoding = "UTF-8"                                       -- The encodeing displayed
o.expandtab = true                                         -- Converts tabs to spaces
o.fileencoding = "UTF-8"                                   -- The encoding written to file
o.formatoptions:append("jtql")                             --
o.formatoptions:remove("cro")                              --
o.gdefault = true                                          --
o.guifont = "JetBrainsMono Nerd Font Mono"                 -- GUI font
o.hidden = true                                            -- Required to keep multiple buffers open at once
o.hlsearch = true                                          --
o.ignorecase = true                                        --
o.inccommand = "nosplit"                                   --
o.incsearch = true                                         -- Start searching before pressing enter
o.laststatus = 2                                           --
o.lazyredraw = true                                        -- Makes macros faster & prevet errors in complicated mappings
o.linebreak = true                                         --
o.list = true                                              -- Turns on whitespace characters
o.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←" -- Sets what to display for whitespace characters
o.mouse = "a"                                              -- Enable mouse
o.number = true                                            -- Show current line number
o.pumblend = 20                                            --
o.redrawtime = 500                                         --
o.relativenumber = true                                    -- Enables relative line numbers
o.ruler = true                                             -- Shows curor position in statusline
o.scrolloff = 4                                            -- Always keep space when scrolling to bottom/top edge
o.shiftwidth = 2                                           -- Insert 2 spaces for a tab
o.shortmess:append("atIcF")                                --
o.showcmd = true                                           -- Shows partical commands
o.showmatch = true                                         -- Breifly shows that matching bracket
o.showmode = false                                         -- Don't show things like -- INSERT -- anymore
o.showtabline = 2                                          -- Always show tabs
o.signcolumn = "yes"                                       -- Add extra sign column next to line number
o.smartcase = true                                         -- Uses case in search
o.smartindent = true                                       -- Makes indenting smart
o.smarttab = true                                          -- Makes tabbing smarter will realize you have 2 vs 4 spaces
o.splitbelow = true                                        -- Horizontal splits will automatically be below buffer
o.splitright = false                                       -- Vertical splits will automatically be to the right
o.swapfile = false                                         -- Recommended for speed
o.synmaxcol = 128                                          --
o.tabstop = 2                                              -- Insert 2 spaces for a tab
o.termguicolors = true                                     -- Correct terminal colors
o.timeoutlen = 600                                         -- Faster completions
-- o.ttimeoutlen = 0                                          --
o.ttyfast = true                                           --
o.undodir = "/home/jace/.cache/nvim/undo"                  -- Dir for undos
o.undofile = true                                          -- Sets undo to file
o.updatetime = 250                                         -- Faster completions
o.visualbell = true                                        -- Enables visual warning for nvim errors
o.winblend = 20                                            --
o.wrap = true                                              -- Wraps long lines after a certain point to the next line
o.writebackup = false                                      -- Recommended for speed

-- Nice menu when typing `:find *.py`
o.wildmode = "longest,list,full"                           -- 
o.wildmenu = true                                          -- 

-- Ignore files
o.wildignore = "*.pyc,*_build/*,**/coverage/*,**/Debug/*,**/build/*,**/node_modules/*,**/android/*,**/ios/*,**/.git/*"

vim.g.did_load_filetypes = 1
vim.g.speeddating_no_mappings = 1
vim.g.dashboard_default_executive = "telescope"

--[[ vim.cmd [[
  filetype indent on

  set t_Co=256
  set t_ut=
  " set shortmess+="c"
  " set noet ci pi sts=0 sw=2 ts=2

  " let g:clipboard = {'copy': {'+': 'pbcopy','*': 'pbcopy'},'paste': {'+': 'pbpaste','*': 'pbpaste'},'name': 'pbcopy','cache_enabled': 0}
  " set clipboard+=unnamedplus

  syntax sync minlines=256

  autocmd BufNewFile,BufRead *.keys set filetype=keys
  autocmd BufNewFile,BufRead *.frag set filetype=glsl
  autocmd BufNewFile,BufRead *.vert set filetype=glsl
  autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
  autocmd BufNewFile,BufRead *.json set filetype=jsonc
  autocmd BufNewFile,BufRead *.h set filetype=c

  " assumes set ignorecase smartcase;
  augroup dynamic_smartcase
    autocmd!
    autocmd CmdLineEnter : set nosmartcase
    autocmd CmdLineLeave : set smartcase
  augroup END

  " Stop annoying you have one more file to edit
  if argc()
    au VimEnter * args %
  endif

  function! GFM()
    let langs = ['lua', 'json', 'js', 'ts', 'jsx', tsx', 'yaml', 'vim', 'c', 'cpp']

    for lang in langs
      unlet b:current_syntax
      silent! exec printf("syntax include @%s syntax/%s.vim", lang, lang)
      exec printf("syntax region %sSnip matchgroup=Snip start='```%s' end='```' contains=@%s", lang, lang, lang)
    endfor
    let b:current_syntax='mkd'

    syntax sync fromstart
  endfunction
] ]]
