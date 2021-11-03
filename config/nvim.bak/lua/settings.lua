local M = {}

local cmd = vim.cmd
local execute = vim.api.nvim_exec

function M.auto_cmds()
  cmd "colorscheme gruvbox-material"

  -- Highlight on yank
  -- cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'
  cmd "au TextYankPost * silent! lua vim.highlight.on_yank()"

  cmd [[
    set expandtab smarttab shiftround autoindent smartindent smartcase
    set path+=**
    set wildmode=longest,list,full
    set wildoptions=pum
    set wildmenu
    set wildignore+=*.pyc
    set wildignore+=*_build/*
    set wildignore+=**/coverage/*
    set wildignore+=**/node_modules/*
    set wildignore+=**/android/*
    set wildignore+=**/ios/*
    set wildignore+=**/.git/*
  ]]

  -- don't auto comment new lines
  cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

  execute(
    [[
      cnoreabbrev W! w!
      cnoreabbrev Q! q!
      cnoreabbrev Qall! qall!
      cnoreabbrev Wq wq
      cnoreabbrev Wa wa
      cnoreabbrev wQ wq
      cnoreabbrev WQ wq
      cnoreabbrev W w
      cnoreabbrev Q q
      cnoreabbrev Qall qall
    ]],
    false
  )

  -- Auto format
  -- vim.api.nvim_exec([[
  -- augroup auto_fmt
  --	autocmd!
  --	autocmd BufWritePre *.py,*.lua,*.rs try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
  -- augroup END
  -- ]], false)

  execute(
    [[
      augroup auto_html
	autocmd!
	autocmd Filetype html setlocal ts=2 sw=2 expandtab
	autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 noexpandtab
      augroup END
    ]],
    false
  )

  execute(
    [[
      augroup auto_term
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber
	autocmd TermOpen * startinsert
      augroup END
    ]],
    false
  )

  execute(
    [[
      fun! TrimWhitespace()
	let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
      endfun

      "-- autocmd FileType * autocmd BufWritePre <buffer> call TrimWhitespace()
    ]],
    false
  )

  -- vim.cmd [[ autocmd CmdWinEnter * quit ]]

  execute(
    [[
      hi InactiveWindow guibg=#282C34
      autocmd VimEnter * set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
    ]],
    false
  )
end

function M.setup()
  M.auto_cmds()
end

return M
