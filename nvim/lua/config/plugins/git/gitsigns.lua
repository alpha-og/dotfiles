-- plugin for showing git decorations

return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_post = "eol",
			delay = 500,
		},
	},
	config = true,
}
