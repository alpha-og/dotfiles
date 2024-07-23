local config = function()
	local lualine = require("lualine")
	local lazy_status = require("lazy.status") -- to configure ...
	local function maximize_status()
		return vim.t.maximized and "   " or ""
	end

	lualine.setup({
		options = {
			theme = "auto",
			globalstatus = true,
			-- component_separators = { left = "|", right = "|" },
			-- section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "buffers" },
			lualine_c = { maximize_status },
			lualine_x = {
				{
					lazy_status.updates,
					cond = lazy_status.has_updates,
				},
				{ "encoding" },
				{ "fileformat" },
				{ "filetype" },
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		tabline = {},
	})
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	config = config,
}
