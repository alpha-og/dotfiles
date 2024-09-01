return {
	"saecki/crates.nvim",
	tag = "stable",
	event = "BufRead",
	ft = "toml",
	config = function()
		require("crates").setup({
			completion = {
				cmp = {
					enabled = true,
				},
			},
		})
	end,
}
