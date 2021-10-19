-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/jace/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/jace/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/jace/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/jace/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/jace/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\1\0025\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/Comment.nvim"
  },
  ShaderHighLight = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/ShaderHighLight"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["coc.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/coc.nvim"
  },
  ["conflict-marker.vim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/conflict-marker.vim"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/editorconfig-vim"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/formatter.nvim"
  },
  ["galaxyline.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["git-blame.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/git-blame.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/jace/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["pears.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/pears.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/quick-scope"
  },
  ["splitjoin.vim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/splitjoin.vim"
  },
  ["startuptime.vim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/startuptime.vim"
  },
  ["telescope-coc.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/telescope-coc.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  undotree = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/undotree"
  },
  ["vim-cool"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-cool"
  },
  ["vim-crates"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-crates"
  },
  ["vim-fetch"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-fetch"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-floaterm"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-highlightedyank"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-highlightedyank"
  },
  ["vim-illuminate"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-illuminate"
  },
  ["vim-lineletters"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-lineletters"
  },
  ["vim-one"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-one"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-polyglot"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-rhubarb"
  },
  ["vim-rooter"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-rooter"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-sandwich"
  },
  ["vim-signify"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-signify"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-test"
  },
  ["vim-todo"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-todo"
  },
  ["vim-toml"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-toml"
  },
  ["vim-wordmotion"] = {
    loaded = true,
    path = "/home/jace/.local/share/nvim/site/pack/packer/start/vim-wordmotion"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\1\0025\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
