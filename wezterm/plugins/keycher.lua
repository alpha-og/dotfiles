local M = {}
local sessions = require("plugins.sessions")
local resurrect = require("plugins.resurrect")
local keys = {}

local apply = function(new_keys)
	for _, v in pairs(new_keys) do
		table.insert(keys, v)
	end
end

apply(sessions.keys)
apply(resurrect.keys)

M.keys = keys
M.apply_keys = function(existing_keys, new_keys)
	for _, v in pairs(new_keys) do
		table.insert(existing_keys, v)
	end
end

return M
