local cmd = vim.cmd
function Source(reload)
    if(reload) then
        require('plenary.reload').reload_module('settings')
	      require('plenary.reload').reload_module('plugins')
	      require('plenary.reload').reload_module('coc')
    end
    require('settings')
    require('plugins')
    require('coc')
    require('Comment').setup()
    require('pears').setup()
end
Source(false)
cmd("command! SourceConfig lua Source(true)")
