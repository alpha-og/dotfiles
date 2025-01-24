local M = {}

M.apply_keys = function(existing_keys, new_keys)
	for _, v in pairs(new_keys) do
		table.insert(existing_keys, v)
	end
end

return M
