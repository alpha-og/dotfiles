-- super fast copilot

return {
	"supermaven-inc/supermaven-nvim",
	commit = "d7125",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-l>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-y>",
			},
			disable_keymaps = true,
			ignore_filetypes = {
				c = true,
				cpp = true,
				rust = true,
			},
		})
		vim.keymap.set("i", "<C-l>", function()
			local luasnip = require("luasnip")
			local suggestion = require("supermaven-nvim.completion_preview")

			if luasnip.expandable() then
				luasnip.expand()
			elseif suggestion.has_suggestion() then
				suggestion.on_accept_suggestion()
			end
		end, {})
	end,
}
