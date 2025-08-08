-- quick access to recently used files/ frequently used files that are manually added by the user

local config = function()
	local harpoon = require("harpoon")
	harpoon:setup({})

	local normalize_list = function(t)
		local normalized = {}
		for _, v in pairs(t) do
			if v ~= nil then
				table.insert(normalized, v)
			end
		end
		return normalized
	end

	vim.keymap.set("n", "<leader>a", function()
		Snacks.picker({
			finder = function()
				local file_paths = {}
				local list = normalize_list(harpoon:list().items)
				for _, item in ipairs(list) do
					table.insert(file_paths, { text = item.value, file = item.value })
				end
				return file_paths
			end,
			win = {
				input = {
					keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
				},
				list = {
					keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
				},
			},
			actions = {
				harpoon_delete = function(picker, item)
					local to_remove = item or picker:selected()
					harpoon:list():remove({ value = to_remove.text })
					harpoon:list().items = normalize_list(harpoon:list().items)
					picker:find({ refresh = true })
				end,
			},
		})
	end, { noremap = true, silent = true, desc = "harpoon picker" })
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = config,
	keys = {
		{
			"<leader>A",
			function()
				require("harpoon"):list():add()
			end,
			desc = "harpoon file",
		},

		{
			"<C-e>",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "harpoon quick menu",
		},
		{
			"<leader>1",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "harpoon to file 1",
		},
		{
			"<leader>2",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "harpoon to file 2",
		},
		{
			"<leader>3",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "harpoon to file 3",
		},
		{
			"<leader>4",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "harpoon to file 4",
		},
		{
			"<leader>5",
			function()
				require("harpoon"):list():select(5)
			end,
			desc = "harpoon to file 5",
		},
	},
}
