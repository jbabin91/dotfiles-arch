require("cfg.disabled")
local status_ok, _ = pcall(require, "impatient")
if status_ok then
	require("impatient")
end
require("cfg.bootstrap") -- plugins configs
require("cfg.globals") -- global configs
require("cfg.editor") -- edit configs
