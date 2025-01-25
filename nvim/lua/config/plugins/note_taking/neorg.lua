return {
	"nvim-neorg/neorg",
	lazy = false,
	version = "*",
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/notes",
						},
						default_workspace = "notes",
					},
				},
				["core.export"] = {},
				["core.summary"] = {},
				["core.integrations.telescope"] = {},
				["core.esupports.metagen"] = {
					config = {
						author = "Athul Anoop",
					},
				},
				["core.integrations.image"] = {},
				["core.latex.renderer"] = {},
			},
		})

		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 2
	end,
	dependencies = {
		"nvim-neorg/neorg-telescope",
	},
}
