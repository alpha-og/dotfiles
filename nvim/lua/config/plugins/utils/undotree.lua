-- plugin for displaying and navigating through undo history

return {
	"mbbill/undotree",
	keys = {
		{ "<leader>ut", vim.cmd.UndotreeToggle, desc = "undotree" },
	},
}
