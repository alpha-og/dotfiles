return {
	"rest-nvim/rest.nvim",
	ft = "http",
	lazy = false,
	dependencies = { "luarocks.nvim" },
	config = function()
		require("rest-nvim").setup()
	end,
}
