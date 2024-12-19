-- plugin for displaying and navigating through undo history

return {
	"mbbill/undotree",
	keys = {
		{ "<leader>u", vim.cmd.UndotreeToggle, desc = "undotree" },
	},
}
